class Interface
    attr_reader :prompt
    attr_accessor :user, :restaurants, :orders, :dishes 
    
    def initialize
        @prompt = TTY::Prompt.new
    end
    
    def run
        welcome
    end

    def welcome#Works
        OrderHere.go
        puts "🥗🍜😁Welcome to FOODIES😁🍜🥗".colorize(:yellow)
        system('say "Welcome to FOODIES"')
        puts ""
        puts "🤤🤤Bet you are starving🤤🤤".colorize(:green)
        sleep 1
        choose_login_or_signup
    end 

    def choose_login_or_signup#works
        puts ""
        prompt.select("Are you logging in or signing up") do |menu|
            menu.choice "Sign up", ->{user_signing_up}
            menu.choice "Log in", ->{user_logging_in}
            menu.choice "Quit App", ->{quit_app}
        end 
    end 
#********************************Signing Up******************************>
    def user_signing_up#works

        user_signing = User.register()
        until user_signing  
            user_logged = User.register()
        end 
        self.user = user_signing
        self.main_menu
    end 
##***************************Logging In**********************************>

    def user_logging_in #need to be done

    end
##**************************Quit App**********************************>
    
    def quit_app#works
        exit!
    end

###**************************Main menu********************************>


#********************************** List of all Restaurants ********>

    def display_all_restaurants
        user.reload
        system "clear"

        # clear previous cart if any
        user.dishes.each {|dish| dish.destroy }

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
        puts "Your current cart" 
        puts " #{user_dishes_names}"
        prompt.select("Do you want to create another order") do |menu|
            menu.choice "Yes Please", -> {continue_with_order}
            menu.choice "No I am done", -> {review_my_cart_0}
            # self.continue_order_menu
        end 
    end 


#************************************** Continue with your order  *******************************>

    def continue_order_menu
        user.reload
        system "clear"
        puts " #{self.user.name} You have completed your first order"
        puts "Your current cart "
        puts " #{user_dishes_names}"
        prompt.select("Do you want to create another order") do |menu|
            menu.choice "Yes Please", -> {continue_with_order}
            menu.choice "No I am done", -> {cart_checkout}
        end 
    end 
        
        
#************************* Continue adding to the order  *************************>

    def continue_with_order
        user.reload
        system "clear"
        # puts "You are here #{user_dishes_names}"
        choosen_restaurant = choosen_restaurant
        chosen_dish = prompt.select("Choose your next dish" ,Dish.all_dishes )

        Order.create(user_id: self.user.id, dish_id: chosen_dish, restaurant_id: choosen_restaurant)
        self.continue_order_menu
    end 

#************************* Cart Menu   ***************************************>

    def cart_checkout
        user.reload
        system "clear"
        puts "#{self.user.name} this is your current cart"
        puts "#{user_dishes_names}"
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
    display_my_cart = user.dishes.map do |dishes|
                    "#{dishes.dish_name} -- $ #{dishes.dish_price}"
                    end 


    # -------- preview my cart -------------
    puts "Hey #{self.user.name} this is your current cart"
    puts "----------------------------------------------"
    puts ""
    puts display_my_cart
    puts ""
    puts "-----------------------------------------------"
    puts ""

    proceed_to_checkout = prompt.yes?("I am happy with the order, let's checkout")
    # USER IS HAPPY WITH THE ORDER, READY TO CHECKOUT
    if proceed_to_checkout
        review_my_cart 
    end 

    cart = prompt.select("Lets Review your cart" ,dishes_hash )
    remove_a_dish = prompt.yes?("Do you want to remove this dish?")

    dish_on_cart = Dish.find(cart)
    
    
# ---------CONDITIONS WHEN REVIEWING THE CART ---------------------------------

# IF THE CART HAS ONLY ONE ORDER AND DESTROYING AN ORDER
    if remove_a_dish == true && user.dishes.count < 2

        # -----helper - methods------------
        orderId = dish_on_cart.id 
        def find_dish_by(dish_id)
            user.orders.find {|dish| dish.dish_id == dish_id}
        end
        
        dish_to_destroy = find_dish_by(orderId).destroy
        
# IF THE CART HAS MORE THAN ONE ORDER AND DESTROYING AN ORDER
    # user.orders
            aide_to_cart
        elsif remove_a_dish == true && user.dishes.count > 1
            orderId = dish_on_cart.id 
            def find_dish_by(dish_id)
                user.orders.find {|dish| dish.dish_id == dish_id}        
            end

            dish_to_destroy = find_dish_by(orderId).destroy

            review_my_cart_0

 # NO ORDER DESTRUCTION 
        else
            review_my_cart 
        end 
    end

#**************** WHEN CART EMPTY - SEND ME BACK TO ALL RESTAURANTS ************

def aide_to_cart
    # binding.pry
    if dishes == nil
        display_all_restaurants
    else
        review_my_cart_0
    end 
end 


# ----------------pick another dish from the cart to remove-------------- 

def continue_removing
    user.reload
    system "clear"

# ------------new array of dishes after the deletion----------------------

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
    tax = subtotal*0.08
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
        puts "We appreciate your bussiness #{self.user.name}"
        puts "            Come again please"
        # binding.pry

        puts "
        
        "

        prompt.select("We hope you enjoyed your order") do |menu|
            menu.choice "Quit the app", -> {quit_app}
            menu.choice "I want to place one more order", -> {display_all_restaurants}
        end


    end 

#--------------------HELPER METHOD -------------------------------------->

    def user_dishes_names
        user.dishes.map do |dish|
            "#{dish.dish_name} $#{dish.dish_price} "
        end 
    end 


    #************************************** Main Menu  *******************************>

    def main_menu#works
        #user.reload 
        system "clear"
        puts "Welcome to the menu #{self.user.name}"
        prompt.select("What would you like to do") do |menu|
            menu.choice "Manage Profile", -> {profile_setup}
            menu.choice "Start My Order", -> {display_all_restaurants}
            menu.choice "Back", -> {choose_login_or_signup}
        end
    end 

    def profile_setup#works
        system 'clear'
        puts "This Is Your Profile"
        @prompt.select("** M Y  P R O F I L E **") do |menu|
            menu.choice "Update Username", -> {change_username_prompt}
            menu.choice "Update Password", -> {change_password_prompt}
            menu.choice "Delete Account", -> {delete_profile_prompt}
            menu.choice "Log Out", -> {log_out}#added exit option
            menu.choice "Back", -> {main_menu}
        end
        sleep 1
    end
    

####***********************Updating Porfile Infos********************************>
            #*************Updating Username*************>

    def change_username_prompt#Works
        system "clear"
        prompt.select("Are you sure you want to edit your username?") do |menu|
            menu.choice "Yes", -> {change_username}
            menu.choice "No", -> {profile_setup}
        end
    end
    def change_username#Works but does not update when doing User.all
        system "clear"
        new_username = @prompt.ask("Enter a new username", required: true)
        self.user.update_attribute(:name, new_username)
        puts "Your username has been updated!"
        sleep 1
        profile_setup
    end

            #************Updating Password***************>

    def change_password_prompt#Works
        system "clear"
        prompt.select("Are you sure you want to edit your password?") do |menu|
            menu.choice "Yes", -> {change_password}
            menu.choice "No", -> {profile_setup}
        end
    end
    def change_password#Works but does not update when doing User.all
        system "clear"
        new_password = @prompt.mask("Enter a new password", required: true)
        self.user.update_attribute(:password, new_password)
        puts "Your password has been updated!"
        sleep 1
        profile_setup
    end
            #*****************Deleting***************>

    def delete_profile_prompt#Works
        prompt.select("Are you sure you want to delete your profile?") do |menu|
            menu.choice "Yes", -> {delete_profile}
            menu.choice "No", -> {profile_setup}
        end
    end

    def delete_profile#Works
        system 'clear'
        self.user.delete
        system 'clear'
        puts "You've succesfully deleted your profile"
        sleep 1
        puts "Sorry to see you leave"
        sleep 2
        choose_login_or_signup#We can do delete or completely exit the app with #quit_app
    end 

            #*****************Logout***************>

    def log_out#Works
        system "clear"
        puts ""
        puts "Thank you for ordering with Foodies"
        sleep 1
        puts "You're now logged out"
        # exit! will exit the CLI app totally
        choose_login_or_signup
    end

end
