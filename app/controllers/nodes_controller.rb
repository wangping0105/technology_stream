#encoding:utf-8
class NodesController < ApplicationController

  before_action :get_nodes,:signed_in_admin?
  def index
    @sections = Section.all
    @nodes = Node.where("section_id = ?",@sections.first)
  end

  def node_list
    @id=params[:id];
    @nodes = Node.where("section_id = ?",params[:id])
  end

  def create_section
    if Section.find_by_name(params[:section_name]).nil?
      flash[:success] = '创建成功'
      Section.create(name:params[:section_name],sort:0)
    else
      flash[:success] = '创建失败！已经存在该名称'
    end
    redirect_to nodes_path
  end
  def destroy_section
     Section.find_by_id(params[:id]).destroy
     flash[:success] = '删除节点成功'
     redirect_to nodes_path
  end
  def destroy_node
     Node.find_by_id(params[:id]).destroy
     flash[:success] = '删除节点成功'
     redirect_to nodes_path
  end
  def create_node
    section_id = params[:id]
    node_name  = params[:node_name]
    node_summary = params[:node_summary]
    node = Node.find_by_name(node_name)
    if node.nil?
      Node.create( name:node_name,
        section_id:section_id,
        summary:node_summary
      )
      @msg="添加成功"
    else
      @msg="添加失败，已经存在节点名称"
    end
    @nodes = Node.where("section_id = ?",section_id)
    get_nodes
  end

  
end