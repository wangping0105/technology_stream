class Message < ActiveRecord::Base

  STATUS ={:have_read=>1,:no_read=>0}
  TYPRS = {:common =>0,:attions=>1}#消息类型0普通回复1是关注帖子回复
end
