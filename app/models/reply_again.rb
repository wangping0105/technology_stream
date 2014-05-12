class ReplyAgain < ActiveRecord::Base
  belongs_to :reply

  def self.get_reply_again reply_ids
      ReplyAgain.select("reply_agains.id,reply_agains.content,reply_agains.target_user_id,
        reply_agains.user_id,reply_agains.reply_id,reply_agains.created_at,reply_agains.updated_at,
        u.id user_id,u.name user_name,u.avatar_url,u1.name user1_name,u1.id user1_id").
        joins("inner join users u on u.id = reply_agains.user_id").
        joins("inner join users u1 on u1.id = reply_agains.target_user_id").
        where("reply_agains.reply_id in (?)",reply_ids)    
  end
end
