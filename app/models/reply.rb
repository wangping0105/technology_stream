class Reply < ActiveRecord::Base
  belongs_to :post,:counter_cache => true
  has_many :reply_agains , :dependent=>:destroy
  PER_PAGE =10

  def self.get_replies post_id,page
    replies = Reply.select("replies.id,replies.content,replies.user_id,
      replies.post_id,replies.created_at,replies.updated_at,
      u.id user_id,u.name user_name,u.avatar_url").
      #joins("inner join post p on p.id = reply.post_id").
      joins("inner join users u on u.id = replies.user_id").
      where("replies.post_id = ?",post_id).order(:created_at=>:asc).paginate(:per_page => PER_PAGE, :page => page)
    return_info = {:page => page, :replies_count => replies.total_pages, :details_replies => replies}
  end
end
