class CreateRestaurants < ActiveRecord::Migration[4.2]
    def change 
        create_table :restaurants do |t|
            t.string :name
        end
    end 
end 