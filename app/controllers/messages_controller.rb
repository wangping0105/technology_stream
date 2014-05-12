class MessagesController < ApplicationController
  before_action :get_nodes,:signed_in_user?


  def empting_messages
     Message.where("target_user_id = ? ",current_user.id).destroy_all
     redirect_to show_messages_page_messages_path
  end

  def show_messages_page
    @messages = Message.where("target_user_id = ? ",current_user.id).order(created_at: :desc).
      select("messages.id,messages.user_id,messages.target_user_id,messages.content,
      messages.post_id,messages.status,messages.types,messages.created_at,messages.updated_at,
      p.title post_title,u.name user_name,u.avatar_url").
      joins("inner join posts p on p.id = messages.post_id ").
      joins("inner join users u on messages.user_id=u.id")

  end
  def show_messages
    count = Message.where("target_user_id = ? and status = 0",current_user.id)
    render text:count.length
  end
end