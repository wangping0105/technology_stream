class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.string :content
      t.integer :types

      t.timestamps
    end
  end
end
