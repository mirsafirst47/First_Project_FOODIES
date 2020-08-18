class CreateDishes < ActiveRecord::Migration[4.2]
    def change 
        create_table :dishes do |t|
            t.string :dish_name
            t.float :dish_price
            t.integer :restaurant_id
        end 
    end 
end 