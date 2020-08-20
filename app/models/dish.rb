class Dish < ActiveRecord::Base
    belongs_to :restaurant
    has_many :orders
    has_many :users, through: :orders



    def self.all_dishes 
        Dish.all.map do |dish|
          dish_id = {"#{dish.dish_name} ............................ $#{dish.dish_price}" => dish.id}
          
        end 
    end 

    def self.find_by_name(name)
        Dish.all.find do |dish|
            dish.dish_name == name
            dish
        end 
    end 

end