class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :node_id
      t.integer :user_id
      t.boolean :status
      t.boolean :cream
      t.integer :reply_count
      t.integer :praise_count
      t.integer :collection_count
      t.integer :browser_count

      t.timestamps
    end
  end
end
