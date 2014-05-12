class AddIndexOrDefaultToTable < ActiveRecord::Migration
  def change
    add_index :posts ,:user_id
    add_index :nodes ,:section_id
  end
end
