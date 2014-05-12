#encoding:utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  def get_nodes
    @sections = Section.all
    @nodes =Node.all
    @nodeses = @nodes.group_by{|s| s[:section_id] }
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
end
