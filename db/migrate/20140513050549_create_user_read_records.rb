class CreateUserReadRecords < ActiveRecord::Migration
  def change
    create_table :user_read_records do |t|
      t.integer :user_id
      t.integer :post_id
      t.float  :times
      t.integer :count,default:0
      t.timestamps
    end
    add_index :user_read_records,:user_id
    add_index :user_read_records,:post_id
  end
end
