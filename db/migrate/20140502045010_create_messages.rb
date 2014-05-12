class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :target_user_id
      t.string :content
      t.integer :post_id
      t.boolean :status
      t.integer :types

      t.timestamps
    end
  end
end
