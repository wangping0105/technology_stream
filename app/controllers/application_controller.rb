#encoding:utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :show_tips,:show_infos
  before_action :end_calculate_time
  include SessionsHelper
  include PostsHelper


  def end_calculate_time
    if !session[:last_controller].blank?&&!session[:beigin_time].nil?&&!session[:post_id].nil?
      time = Time.now - session[:beigin_time].to_datetime
      user_record = UserReadRecord.find_by_user_id_and_post_id(current_user.id,session[:post_id])
      if user_record.nil?
        UserReadRecord.create(times:time,user_id:current_user.id,post_id:session[:post_id],count:1);
      else
        user_record.update_attributes(times:(user_record.times+time),count:(user_record.count+1))
      end
      session[:last_controller]=nil
      session[:beigin_time] = nil
      session[:post_id] = nil
    end
  end

  def get_nodes
    @left_sections = Section.all
    @left_nodes =Node.all
    @left_nodeses = @left_nodes.group_by{|s| s[:section_id] }
  end
  def signed_in_user?
    unless signed_in?
      store_location
      redirect_to sessions_path,notice:'请先登陆~'
    end
  end
  def signed_in_admin?
    unless current_user && current_user.admin?
      redirect_to root_path,notice:'请先登陆~'
    end
  end

  def show_tips
    tips = Tip.all
    r = Random.new
    index = r.rand(0...tips.length)
    @tip = tips[index]
  end
  def show_infos
    @users_count =User.select("count(*) count")
    @posts_count =Post.select("count(*) count")
    @replies_count =Reply.select("count(*) count")
  end
end
