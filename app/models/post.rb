  require 'will_paginate/array'
class Post < ActiveRecord::Base
  belongs_to :node,:counter_cache => true
  has_many :replies,:dependent => :destroy

  scope :cream,conditions:{cream:1}
  STATUS ={:freeze=>0,:nomal =>1}
  PER_PAGE = 12
  
  def self.get_posts page, id =nil ,node_id =nil,section_id =nil,cream =nil,status =nil
    base_sql ="
    select p.id,p.title,p.content,p.user_id,p.status,p.cream,p.replies_count,p.praises_count,p.collections_count,
p.attentions_count,p.browser_count,p.created_at,p.updated_at,u.name user_name ,u.id user_id ,u.avatar_url,
    n.name node_name,n.id node_id,n.posts_count,s.name section_name from posts p
    left join users u on p.user_id=u.id
    left join nodes n on p.node_id = n.id
    left join sections s on n.section_id = s.id
    "
    condition_sql = "where  p.status=1 "
    params_arr = [""]
    unless id.nil?
      condition_sql += " and p.id = ? "
      params_arr << id
    end
    unless node_id.nil?
      condition_sql += " and p.node_id = ? "
      params_arr << node_id
    end
    unless section_id.nil?
      condition_sql += " and p.section_id  = ? "
      params_arr << section_id
    end
    unless cream.nil?
      condition_sql += " and p.cream = ? "
      params_arr << cream
    end
    unless status.nil?
      condition_sql += " and p.status = ? "
      params_arr << status
    end
    condition_sql +="order by created_at desc"
    params_arr[0] = base_sql + condition_sql
    posts = Post.find_by_sql(params_arr).paginate(:per_page => PER_PAGE, :page => page)
    return_info = {:page => page, :pages_count => posts.total_pages, :details_posts => posts}
  end


  def self.get_repliest_post page
    base_sql ="
    select p.id,p.title,p.content,p.status,p.cream,p.replies_count,p.praises_count,p.collections_count,
    p.attentions_count,p.browser_count,p.created_at,p.updated_at,u.name user_name ,u.id user_id ,
    u.avatar_url,n.name node_name,n.id node_id ,s.name section_name from posts p
    left join users u on p.user_id=u.id
    left join nodes n on p.node_id = n.id
    left join sections s on n.section_id = s.id
    "
    condition_sql = "where  p.status=1 "
    params_arr = [""]
    condition_sql +="order by updated_at desc"
    params_arr[0] = base_sql + condition_sql
    posts = Post.find_by_sql(params_arr).paginate(:per_page => PER_PAGE, :page => page)
    return_info = {:page => page, :pages_count => posts.total_pages, :details_posts => posts}
  end

  def self.get_no_reply_post page
    base_sql ="
    select p.id,p.title,p.content,p.status,p.cream,p.replies_count,p.praises_count,p.collections_count,
    p.attentions_count,p.browser_count,p.created_at,p.updated_at,u.name user_name ,u.id user_id ,
    u.avatar_url,n.name node_name,n.id node_id ,s.name section_name from posts p
    left join users u on p.user_id=u.id
    left join nodes n on p.node_id = n.id
    left join sections s on n.section_id = s.id
    "
    condition_sql = "where (p.status=1 and p.replies_count = 0)"
    params_arr = [""]
    condition_sql +="order by created_at desc"
    params_arr[0] = base_sql + condition_sql
    posts = Post.find_by_sql(params_arr).paginate(:per_page => PER_PAGE, :page => page)
    return_info = {:page => page, :pages_count => posts.total_pages, :details_posts => posts}
  end

  def self.get_search_post page,content
    base_sql ="
    select p.id,p.title,p.content,p.status,p.cream,p.replies_count,p.praises_count,p.collections_count,
    p.attentions_count,p.browser_count,p.created_at,p.updated_at,u.name user_name ,u.id user_id ,
    u.avatar_url,n.name node_name ,n.id node_id,s.name section_name from posts p
    left join users u on p.user_id=u.id
    left join nodes n on p.node_id = n.id
    left join sections s on n.section_id = s.id
    "
    condition_sql = "where (p.status=1 and (p.title like ? ))"
    params_arr = ["","%#{content}%"]
    condition_sql +="order by created_at desc"
    params_arr[0] = base_sql + condition_sql
    posts = Post.find_by_sql(params_arr).paginate(:per_page => PER_PAGE, :page => page)
    return_info = {:page => page, :pages_count => posts.total_pages, :details_posts => posts}
  end

  def self.get_popular_post page
    base_sql ="
    select p.id,p.title,p.content,p.status,p.cream,p.replies_count,p.praises_count,p.collections_count,
    p.attentions_count,p.browser_count,p.created_at,p.updated_at,u.name user_name ,u.id user_id ,
    u.avatar_url,n.name node_name ,n.id node_id,s.name section_name from posts p
    left join users u on p.user_id=u.id
    left join nodes n on p.node_id = n.id
    left join sections s on n.section_id = s.id
    "
    condition_sql = "where (p.status=1)"
    params_arr = [""]
    condition_sql +="order by (p.replies_count*0.1+p.collections_count*0.4+p.attentions_count*0.2+p.praises_count*0.3) desc"
    params_arr[0] = base_sql + condition_sql
    posts = Post.find_by_sql(params_arr).paginate(:per_page => PER_PAGE, :page => page)
    return_info = {:page => page, :pages_count => posts.total_pages, :details_posts => posts}
  end

end
