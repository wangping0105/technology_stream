#encoding:utf-8
class ClientsController < ApplicationController
  before_action :get_nodes#,:signed_in_user?
  #skip_before_action :signed_in_user?, :only => [:top_100_members]
  PER_PAGE = 10
  def index
    if params[:format].nil?
      @target_user = current_user
    else
      @target_user = User.find_by_id(params[:format])
    end
    @liked_posts = Post.select("posts.id,posts.title,posts.content,posts.status,posts.cream,
    posts.replies_count,posts.praises_count,posts.collections_count,
    posts.attentions_count,posts.browser_count,posts.created_at,
    posts.updated_at,n.name node_name ,s.name section_name").
      where("user_id = ?",@target_user.id).order(cream: :desc).limit(10).
      joins("left join nodes n on posts.node_id = n.id").
      joins("left join sections s on n.section_id = s.id")
    
    @replyed_posts = Reply.select("replies.id,replies.post_id,replies.content,
      replies.created_at,p.title post_title").
      where("replies.user_id = ?",@target_user.id).
      joins("inner join posts p on p.id = replies.post_id").
      order(created_at: :desc).limit(10)
  end

  def my_posts
    if params[:format].nil?
      @target_user = current_user
    else
      @target_user = User.find_by_id(params[:format])
    end
    @my_posts = Post.select("posts.id,posts.title,posts.content,posts.status,posts.cream,
    posts.replies_count,posts.praises_count,posts.collections_count,
    posts.attentions_count,posts.browser_count,posts.created_at,
    posts.updated_at,n.name node_name ,s.name section_name").
      where("user_id = ?",@target_user.id).order(created_at: :desc).
      joins("left join nodes n on posts.node_id = n.id").
      joins("left join sections s on n.section_id = s.id").paginate(page:params[:page],per_page: PER_PAGE )
  end

  def my_collections
    if params[:format].nil?
      @target_user = current_user
    else
      @target_user = User.find_by_id(params[:format])
    end
    @my_collections =Post.select("posts.id,posts.title,posts.content,posts.status,posts.cream,
    posts.replies_count,posts.praises_count,posts.collections_count,
    posts.attentions_count,posts.browser_count,posts.created_at,
    posts.updated_at,n.name node_name ,s.name section_name,u.name user_name").
      where("c.user_id = ?",@target_user.id).order(created_at: :desc).
      joins("left join nodes n on posts.node_id = n.id").
      joins("left join users u on posts.user_id = u.id").
      joins("left join collections c on posts.id = c.post_id").
      joins("left join sections s on n.section_id = s.id").paginate(page:params[:page],per_page: PER_PAGE )
  end

  def my_diaries
    if params[:format].nil?
      @target_user = current_user
    else
      @target_user = User.find_by_id(params[:format])
    end
  end

  def client_info
    @target_user = current_user
    @provinces = Province.all
    if @target_user.location.nil?
      @cites = City.where("provincecode = 110000")
    else
      @city = City.where("code = ?",@target_user.location)[0]
      @cites = City.where("provincecode = ?",@city.provincecode) if @city
    end

    p 1111111,@cites,222
  end

  def top_100_members
    @user_count = User.select("count(*) count")
    @users = User::all.limit(50);
  end

  def search_citties
    provincecode = params[:provincecode].to_i
    @cities = City.where(["provincecode = ?", provincecode])
    render :json => {:cities => @cities}
  end
  
end