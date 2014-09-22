class AddIndexToSomeTables < ActiveRecord::Migration
  def change
    add_index :tags_post_relations,:tag_id
    add_index :tags_post_relations,:post_id
    add_index :tags,:content
    add_index :replies,:post_id
    add_index :replies,:user_id
    add_index :reply_agains,:reply_id
    add_index :posts,:title
    add_index :messages,:user_id
  end
end
