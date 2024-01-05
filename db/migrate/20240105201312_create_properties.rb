class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.string :type
      t.string :operation_type
      t.integer :price
      t.string :currency_type
      t.references :commune, null: false, foreign_key: true
      t.text :address
      t.integer :area
      t.integer :rooms_number
      t.integer :bathrooms_number
      t.text :description

      t.timestamps
    end
  end
end
