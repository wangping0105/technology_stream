#encoding:utf-8
class SessionsController < ApplicationController
  layout 'session'
  def index
  end
  def create
    @user = User.find_by_email(params[:sessions][:login])||User.find_by_name(params[:sessions][:login])
    if @user && @user.authenticate(params[:sessions][:password])
      flash[:success] = '登录成功'
      sign_in @user
      redirect_back_or root_path
    else
      flash[:error] = '登录失败,帐号或密码错误！'
      render 'index'
    end
  end
end
