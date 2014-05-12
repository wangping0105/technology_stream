#encoding:utf-8
class PostsController < ApplicationController
  before_action :get_nodes,:store_location,:signed_in_user?
  skip_before_action :signed_in_user?, :only => [:index,:all_index,:show,:show_last,:diff_categories_post,:no_reply,:popular,:last_created]
  skip_before_filter :verify_authenticity_token, :only => [:create_reply_again]
  def index
    @posts = Post::get_posts(1,nil,nil,nil,1,nil)[:details_posts]
  end
  def all_index
    @posts = Post::get_repliest_post(params[:page])[:details_posts]
  end
  def popular
    @posts = Post::get_popular_post(params[:page])[:details_posts]
    render 'all_index'
  end

  def no_reply
    @posts = Post::get_no_reply_post(params[:page])[:details_posts]
    render 'all_index'
  end

  def last_created
    @posts = Post::get_posts(params[:page],nil,nil,nil,nil,nil)[:details_posts]
    render 'all_index'
  end

  def diff_categories_post
    @node = Node.find_by_id(params[:id])
    @posts = Post::get_posts(params[:page],nil,params[:id],nil,nil,nil)[:details_posts]
  end


  def new
    @post = Post.new
    @nodes = Node.all
  end

  def show
    page=1
    unless params[:page].nil?
      page = params[:page].to_i
    end
    @post = Post::get_posts(1,params[:id],nil,nil,nil,nil)[:details_posts][0]
    @replies = Reply::get_replies(@post.id,params[:page])[:details_replies]
    @last_count = (page-1)*Reply::PER_PAGE
    reply_ids = @replies.map(&:id)
    reply_agains = ReplyAgain::get_reply_again(reply_ids)
    @reply_again_gruops = reply_agains.group_by{|s| s.reply_id}
    if current_user
      collections = Collection.where("post_id = ? and user_id=?  ",params[:id],current_user.id )
      praises = Praise.where("post_id = ? and user_id=?   ",params[:id],current_user.id)
      attentions = Attention.where("post_id = ? and user_id=?  ",params[:id],current_user.id )
      @collection_ids =collections.map(&:user_id)||[]
      @praise_ids = praises.map(&:user_id)||[]
      @attention_ids = attentions.map(&:user_id)||[]
    end
  end

  def show_last
    @post = Post::get_posts(1,params[:id],nil,nil,nil,nil)[:details_posts][0]
    page = 0
    if params[:page].nil? && !@post.replies_count.nil?
      page =@post.replies_count/(Reply::PER_PAGE-1)+1
    else
      page = params[:page].to_i
    end
    page = 1 if page==0
    @replies = Reply::get_replies(@post.id,page)[:details_replies]
    @last_count = (page-1)*Reply::PER_PAGE
    reply_ids = @replies.map(&:id) 
    reply_agains = ReplyAgain::get_reply_again(reply_ids)
    @reply_again_gruops = reply_agains.group_by{|s| s.reply_id}
    if current_user
      collections = Collection.where("post_id = ? and user_id=?  ",params[:id],current_user.id )
      praises = Praise.where("post_id = ? and user_id=?   ",params[:id],current_user.id)
      attentions = Attention.where("post_id = ? and user_id=?  ",params[:id],current_user.id )
      @collection_ids =collections.map(&:user_id)||[]
      @praise_ids = praises.map(&:user_id)||[]
      @attention_ids = attentions.map(&:user_id)||[]
    end
    render 'show'
  end


  def edit
    @post = Post.find(params[:id])
  
  end
  def update
    @post = Post.find(params[:id])
    if @post
      @post.update_attributes(title:params[:post][:title],
        content:params[:post][:content],
        node_id:params[:post][:node])
      flash[:success] = '更新成功！'
      redirect_to post_path(@post)
    else
      flash[error] = '更新失败，帖子已删除'
      render 'edit'
    end
  end
  def create
    title = params[:post][:title].strip
    node_id = params[:post][:node]
    content = params[:post][:content]
    post = Post.new do |p|
      p.title = title
      p.node_id = node_id
      p.content = content
      p.user_id = current_user.id
      p.status = Post::STATUS[:nomal]
      p.replies_count = 0
      p.collections_count = 0
      p.praises_count = 0
      p.attentions_count = 0

    end
    if post.save
      flash[:success] = '帖子创建成功！'
      redirect_to post_path(post)
    else
      flash[:error] = '帖子创建失败！'
      render 'new'
    end

  end

  def destroy
    post = Post.find_by_id(params[:id])
    if post && post.destroy!
      flash[:success]='删除帖子成功！'
    else
      flash[:success]='删除失败！帖子已经不存在'
    end
    redirect_to root_path
  end

  def create_reply
    post_id = params[:post_id]
    post = Post.find_by_id(post_id)
    unless post.nil?
      post.update_attribute(:updated_at, Time.now)
      content = params[:reply_content]
      Reply.create(content:content,
        post_id:post_id,
        user_id:current_user.id)
      flash[:success] = '回复成功！'
      if post.user_id != current_user.id
        Message.create(content:content,
          post_id:post_id,
          target_user_id:post.user_id,
          user_id:current_user.id,
          status:Message::STATUS[:no_read],
          types:Message::TYPRS[:common])
      end
      redirect_to post_path(post_id)
    else
      flash[:success] = '回复失败！'
      redirect_to post_path(post_id)
    end
  end

  def create_reply_again
    target_user_id =  params[:target_user_id]
    reply_id = params[:reply_id]
    reply = Reply.find_by_id(reply_id)
    if reply
      content = params[:reply_again_content]
      ReplyAgain.create(
        content:content,
        target_user_id:target_user_id,
        reply_id:reply_id,
        user_id:current_user.id
      )
      if post.user_id != current_user.id
        Message.create(content:content,
          post_id:reply.post_id,
          user_id:current_user.id,
          target_user_id:target_user_id,
          status:Message::STATUS[:no_read],
          types:Message::TYPRS[:common])
      end
      render text:1
    else
      render text:0
    end
  end

  def search_posts
    @content = params[:search_content].strip
    @posts = Post::get_search_post(params[:page],@content)[:details_posts]
  end

  def collection_post
    Collection.create(
      post_id:params[:id],
      user_id:current_user.id
    )
    flash[:success] = '您已收藏该贴'
    redirect_to post_path(params[:id])
  end
  def dis_collection_post
    common_dis_collection params[:id],current_user.id 
    flash[:success] = '您已取消收藏该贴'
    redirect_to post_path(params[:id])
  end
  def dis_collection_post_in_user_info
    common_dis_collection params[:id],current_user.id
    flash[:success] = '您已取消收藏该贴'
    redirect_to my_collections_clients_path(params[:id])
  end


  def praise_post
    Praise.create(
      post_id:params[:id],
      user_id:current_user.id
    )
    flash[:success] = '您已赞该贴'
    redirect_to post_path(params[:id])
  end
  def dis_praise_post
    praise = Praise.find_by_user_id_and_post_id(current_user.id,params[:id] )
    if praise
      praise.destroy
    end
    flash[:success] = '您已取消赞该贴'
    redirect_to post_path(params[:id])
  end

  def attention_post
    Attention.create(
      post_id:params[:id],
      user_id:current_user.id
    )
    flash[:success] = '您已关注该贴'
    redirect_to post_path(params[:id])
  end
  def dis_attention_post
    attention = Attention.find_by_user_id_and_post_id(current_user.id,params[:id] )
    if attention
      attention.destroy
    end
    flash[:success] = '您已取消关注该贴'
    redirect_to post_path(params[:id])
  end

  private
  def post_params
    params.require(:posts).permit(:title,:content)
  end

  def common_collection post_id,user_id
    Collection.create(
      post_id:post_id,
      user_id:user_id
    )
  end
  def common_dis_collection post_id,user_id
    collection = Collection.find_by_user_id_and_post_id(user_id,post_id )
    if collection
      collection.destroy
    end
  end
end
