class Restaurant < ActiveRecord::Base
    has_many :dishes
    has_many :orders, through: :dishes




    def self.list 
    Restaurant.all.map do |restaurant|
        {restaurant.name => restaurant.id}
    end 
end 
end 