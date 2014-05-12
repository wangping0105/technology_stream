class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :location
      t.integer :qq
      t.string :website
      t.integer :role
      t.boolean :status
      t.string :github
      t.integer :sex

      t.timestamps
    end
  end
end
