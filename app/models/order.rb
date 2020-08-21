class Order < ActiveRecord::Base
    belongs_to :user
    belongs_to :restaurant
    belongs_to :dish

    def self.list 
        Order.all.map(&:id)
    end 
end