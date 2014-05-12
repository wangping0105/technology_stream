class CreateReplyAgains < ActiveRecord::Migration
  def change
    create_table :reply_agains do |t|
      t.string :content
      t.integer :user_id
      t.integer :target_user_id
      t.integer :reply_id

      t.timestamps
    end
  end
end
