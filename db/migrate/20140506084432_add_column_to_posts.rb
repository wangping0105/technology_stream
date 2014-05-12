class AddColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :collections_count, :integer
    add_column :posts, :praises_count, :integer
    add_column :posts, :attentions_count, :integer
    remove_column :posts , :collection_count
    remove_column :posts , :praise_count
  end
end
