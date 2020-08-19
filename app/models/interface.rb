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
#********************************login******************************>
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


#************************************** List of all Restaurants ********>

    def display_all_restaurants
        pick_a_restaurant = prompt.select("Choose a Restaurant to start your order" ,Restaurant.list)
            @choosen_restaurant = Restaurant.find(pick_a_restaurant)
            
    # ----Dishes for the curent user --------
      
        chosen_dish = prompt.select("Choose your first dish" ,Dish.all_dishes )

    # ___Create a new Order using the options from the current user ______
        Order.create(user_id: self.user.id, dish_id: chosen_dish, restaurant_id: @choosen_restaurant)
        self.order_menu
    end 


#************************************** Order Menu  *******************************>

    def order_menu
        user.reload
        system "clear"
        puts " #{self.user.name} You have completed your first order"
        puts "you have added #{user_dishes_names}"
        prompt.select("Do you want to create another order") do |menu|
            menu.choice "Yes Please", -> {continue_with_order}
            menu.choice "No I am done", -> {puts "exit"}
            # self.continue_order_menu
        end 
    end 


# #************************************** Continue with your order  *******************************>

    def continue_order_menu
        user.reload
        system "clear"
        puts " #{self.user.name} You have completed your first order"
        puts "you have added #{user_dishes_names}"
        prompt.select("Do you want to create another order") do |menu|
            menu.choice "Yes Please", -> {continue_with_order}
            menu.choice "No I am done", -> {cart_checkout}
        end 
    end 
        
        

#************************* Continue adding to the order  *************************>

    def continue_with_order
        user.reload
        system "clear"
        puts "You are here #{user_dishes_names}"
        choosen_restaurant = choosen_restaurant
        chosen_dish = prompt.select("Choose your next dish" ,Dish.all_dishes )

        Order.create(user_id: self.user.id, dish_id: chosen_dish, restaurant_id: choosen_restaurant)
        self.continue_order_menu
    end 

#************************* Cart Menu   ***************************************>

    def cart_checkout
        user.reload
        system "clear"
        puts "You are here #{user_dishes_names}"
        prompt.select("Lets go to to your cart") do |menu|
            menu.choice "No, I meant to add another dish to my cart", -> {continue_with_order}
            menu.choice "Sure, lets go to cart", -> {review_my_cart_0}
        end
        
    end 


# ***************** Review My Cart ***********************************

def review_my_cart_0
    user.reload
    system "clear"

    dishes = user.dishes.map(&:id)

    dishes_hash = user.dishes.map do |dish|
       { "#{dish.dish_name}  $#{dish.dish_price}" => dish.id }
    end  

#   ------Reviewing my cart and choosing to remove dishes if I want to-------------- 
    cart = prompt.select("Review your cart" ,dishes_hash )
    prompt.yes?("Do you want to remove this dish?")

 
    Order.find(cart).destroy
    Dish.find(cart).destroy
    # binding.pry
    prompt.select("Do you want to remove another dish?") do |menu|
        menu.choice "Yes", -> {continue_removing}
        menu.choice "No, I am ready for checkout now", -> {review_my_cart}
    end
end 


#   ----------------pick another dish from the cart to remove-------------- 

def continue_removing
    user.reload
    system "clear"

# ------------new array of dishes after the deletion-----        
    dishes_hash_2 = user.dishes.map do |dish|
        { "#{dish.dish_name}  $#{dish.dish_price}" => dish.id }
     end  


cart = prompt.select("Do you want to remove another dish?" ,dishes_hash_2 )
prompt.yes?("Do you want to remove this dish?")

# getting the name of the dish 
    Order.find(cart).destroy
    Dish.find(cart).destroy
    

# binding.pry
prompt.select("Do you want to remove another dish?") do |menu|
    menu.choice "Yes", -> {continue_removing}
    menu.choice "No, I am ready for checkout now", -> {review_my_cart}
end

end 




    
#********************review my cart **********************************>

    def review_my_cart
        user.reload
        system "clear"

# ------ HELPER METHODS FOR THE CART -----------------------
    # -----mapping the dishes into a hash
    dishes_hash = user.dishes.map do |dish|
        "#{dish.dish_name} $#{dish.dish_price}"
    end  

    # ------grouping dishes by name
    group_the_dishes = dishes_hash.group_by { |dish_name| dish_name} 
    dishes_grouped_by_name = group_the_dishes.map { |dish_name, dish_price| "  #{dish_price.size} ............... #{dish_name}" }

    # -------mathematical logic for the receipt 
    subtotal = user.dishes.sum(&:dish_price)
    tax = subtotal*1.20
    total = subtotal + tax
    gratuity = subtotal * 0.2

# ----------------BODY OF THE RECEIPT-------------------------------------
        puts " "
        puts "       🥗🍜😁Welcome to FOODIES😁🍜🥗   " 
        puts "    We are located in the Avatar Kingdom"
        puts "          www.TheCodeBenders.com"
        puts " "

        puts " You placed your order at #{@choosen_restaurant.name.upcase} Restaurant"
        puts " "

        puts "********************************************"

        puts "Quantity                   Dish"
        puts " "
        puts dishes_grouped_by_name
        puts "
        "
        
        puts " Subtotal =  $#{subtotal.round(2)}"
        puts " Tax = $#{tax.round(2)}"
        puts " TOTAL = $#{total.round(2)}"
        puts " Gratuity 😁 = $#{gratuity.round(2)}"
        puts "
        "
        puts '----------------------------------------------'
        puts "We appreciate your bussiness, come again please"
        # binding.pry


    end 

#--------------------HELPER METHOD -------------------------------------->

    def user_dishes_names
        user.dishes.map do |dish|
            "#{dish.dish_name} #{dish.dish_price} "
        end 
        # user.dishes.map(&:dish_name)
    end 


    #************************************** Main Menu  *******************************>
    def main_menu
        user.reload
        system "clear"
        puts "Welcome to the dark side #{self.user.name}"
        prompt.select("What else can we do") do |menu|
            menu.choice "Some choice", -> {puts "Profile_method"}
            menu.choice "Start my order", -> {display_all_restaurants}
        end 
    end 


end 
