class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.integer :section_id
      t.integer :sort
      t.integer :posts_count
      t.string :summary

      t.timestamps
    end
  end
end
