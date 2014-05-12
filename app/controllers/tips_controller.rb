#encoding:utf-8
class TipsController < ApplicationController
   before_action :get_nodes,:signed_in_admin?
  def index
    @tips = Tip.all
  end
  def create
    content = params[:tip_content]
    Tip.create(content:content)
    flash[:success] = '创建成功！'
    redirect_to tips_path
  end
  def destroy
    tip = Tip.find_by_id(params[:id])
    tip.destroy
    flash[:success] = '删除成功！'
    redirect_to tips_path
  end
end
