class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remark, :string
  end
end
