class CreateTagsPostRelations < ActiveRecord::Migration
  def change
    create_table :tags_post_relations do |t|
      t.integer :tag_id
      t.integer :post_id

      t.timestamps
    end
  end
end
