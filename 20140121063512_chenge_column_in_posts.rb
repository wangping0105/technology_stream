class ChengeColumnInPosts < ActiveRecord::Migration
  def change
    remove_column :posts ,:reply_count
    add_column :posts ,:replies_count ,:integer
  end
end
