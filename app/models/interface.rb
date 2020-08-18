class Interface
    attr_reader :prompt
    attr_accessor :user, :restaurants, :orders, :dishes 

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome 
        OrderHere.go
        puts "🥗🍜😁Welcome to FOODIES😁🍜🥗"
        system('say "Welcome to FOODIES"')
        puts "Bet you are starving"
    end 

    def choose_login_or_signup
        prompt.select("Are you logging in or registering") do |menu|
            menu.choice "Logging in", ->{user_logging_in}
            menu.choice "Signing up", ->{user_signing_up}
        end 
    end 

    def user_logging_in
        user_logged = User.register()
        until user_logged 
            user_logged = User.register()
        end 
        self.user = user_logged
        self.main_menu
    end 

    def main_menu
        user.reload
        system "clear"
        puts "Welcome to the dark side #{self.user.name}"
        prompt.select("What else can we do") do |menu|
            menu.choice "Some choice", -> {puts "Comming soon"}
            menu.choice "Start my order", -> {display_all_restaurants}
        end 
    end 

    def display_all_restaurants
        choosen_restaurant_id = prompt.select("Choose a Restaurant to start your order" ,Restaurant.list)
        
        choosen_restaurant = Restaurant.find(choosen_restaurant_id)
        dishes = choosen_restaurant.dishes
        dishes
        prompt.select("Choose your first dish" ,Dish.all_dishes )

        
    end 

 



    # def make_an_order
    #     Order.all.each do |order|
    #         puts order.order_id
    #     end
    # end 

  

end 
