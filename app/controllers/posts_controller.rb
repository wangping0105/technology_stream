#encoding:utf-8
class PostsController < ApplicationController
  before_action :get_nodes,:signed_in_user?
  after_action :setting_post ,:only =>  [:collection_post,:dis_collection_post,:dis_collection_post_in_user_info,:praise_post,:dis_praise_post,:attention_post,:dis_attention_post]
  skip_before_action :signed_in_user?, :only => [:search_posts,:index,:all_index,:show,:show_last,:diff_categories_post,:no_reply,:popular,:last_created]
  skip_before_filter :verify_authenticity_token, :only => [:create_reply_again]
  #记录浏览时间
  before_action :end_calculate_time
  skip_before_action :end_calculate_time,:only=>[:create_reply_again,:create_reply,:show,:collection_post,:dis_collection_post,:dis_collection_post_in_user_info,:praise_post,:dis_praise_post,:attention_post,:dis_attention_post]
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
    #得到再回复
    reply_ids = @replies.map(&:id)
    reply_agains = ReplyAgain::get_reply_again(reply_ids)
    @reply_again_gruops = reply_agains.group_by{|s| s.reply_id}
    if current_user&&current_user.admin?
      @post_infos =get_reply_count (params[:id])
    end
    get_tags_form(params[:id])
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
    if current_user&&current_user.admin?
      @post_infos = get_reply_count (params[:id])
    end
    get_tags_form(params[:id])
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
    tags = Tag.select("tags.id,tags.content").where("t.post_id = ?",@post.id).
      joins("inner join tags_post_relations t on t.tag_id = tags.id")
    @tags = tags.map(&:content).join(";")
    
    
  end
  def update
    @post = Post.find(params[:id])
    if @post
      @post.update_attributes(title:params[:post][:title],
        content:params[:post][:content],
        node_id:params[:post][:node])
      TagsPostRelation.destroy_all("post_id = #{@post.id}")
      add_tag_to_post params[:post][:tags].strip,@post
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
    @post = Post.new do |p|
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
    p = Post.where("title = ? and created_at > ?",title,(Time.now-3600))
    if p.blank? && @post.save
      add_tag_to_post params[:post][:tags].strip,@post
      flash[:success] = '帖子创建成功！'
      redirect_to post_path(@post)
    elsif !p.blank?
      flash[:error] = '帖子创建失败！短时间内标题不能重复'
      render 'new'
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
      attens = Attention.where("post_id=?",post_id)
      unless attens.blank?
        attens.each do |a|
          Message.create(content:content,
            post_id:post_id,
            target_user_id:a.user_id,
            user_id:current_user.id,
            status:Message::STATUS[:no_read],
            types:Message::TYPRS[:attions])
        end
      end
      redirect_to post_path(post_id)
    else
      flash[:success] = '回复失败！'
      redirect_to post_path(post_id)
    end
  end

  def delete_reply
    reply =  Reply.find_by_id(params[:reply_id])
    reply.destroy
    flash[:success] = '删除成功！'
    redirect_to post_path(params[:id])
  end
  def delete_reply_again
    reply =  ReplyAgain.find_by_id(params[:reply_again_id])
    reply.destroy
    flash[:success] = '删除成功！'
    redirect_to post_path(params[:id])
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
      post = Post.find_by_id(reply.post_id)
      if target_user_id.to_i !=current_user.id
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
    redirect_to my_collections_clients_path
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

  def add_tag_to_post tags_str,post
    tags_str.split(";").each do |tag|
      tag_i = Tag.find_by_content(tag)
      if tag_i
        TagsPostRelation.create(post_id:post.id,tag_id:tag_i.id)
      else
        this_tag = Tag.create(content:tag)
        TagsPostRelation.create(post_id:post.id,tag_id:this_tag.id)
      end
    end
  end
  def get_tags_form(post_id)
    @tags = Tag.select("tags.id,tags.content").where("t.post_id = ?",post_id).
      joins("inner join tags_post_relations t on t.tag_id = tags.id")
  end
  def get_reply_count post_id
    user_record = UserReadRecord.where("post_id = ?" , post_id)
    reading_count = user_record.length
    reading_time = 0
    user_record.each do |u_r|
      reading_time+=u_r.times
    end
    {reading_count:reading_count,reading_time:reading_time}
  end
end
