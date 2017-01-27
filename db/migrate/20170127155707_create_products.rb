class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.text :description
      t.decimal :price
      t.integer :quantity
      t.string :img
      t.string :category

      t.timestamps
    end
  end
end
