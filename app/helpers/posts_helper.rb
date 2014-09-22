module PostsHelper
  def setting_post
    post = Post.find_by_id(params[:id])
    creams = post.collections_count.to_i*0.2+post.praises_count.to_i*0.5+post.attentions_count.to_i*0.3
    if creams > 20
      post.update_attribute(:cream,1)
    end
  end
end
