class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :code
      t.string :name
      t.integer :provincecode

      t.timestamps
    end
  end
end
