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

    # def self.user_dishes 
    #     user.dishes.map do |dish|
    #         "#{dish.dish_name} ....... from #{dish.restaurant.id.name} "
    #     end 
    # end 

end