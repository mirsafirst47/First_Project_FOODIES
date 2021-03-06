class Interface

    attr_reader :prompt
    attr_accessor :user, :restaurants, :orders, :dishes
    
    def initialize
        @prompt = TTY::Prompt.new
    end
    
    def run
        welcome
    end
    
    def welcome #Done
        system('say "Welcome to FOODIES"')
        OrderHere.starter
        
        puts "🥗🍜😁Welcome to FOODIES😁🍜🥗".colorize(:yellow)
        puts ""
        puts "🤤🤤Bet you are starving🤤🤤".colorize(:green)
        sleep 1
        choose_login_or_signup
    end 

    def choose_login_or_signup #Done
        system "clear"
        puts "🥗🍜😁Welcome to FOODIES😁🍜🥗".colorize(:yellow)
        puts ""
        puts "🤤🤤Bet you are starving🤤🤤".colorize(:green)
        puts ""
        OrderHere.header
        prompt.select("Are you logging in or signing up") do |menu|
            menu.choice "Sign up", ->{user_signing_up}
            menu.choice "Log in", ->{user_logging_in}
            menu.choice "Quit App", ->{quit_app}
        end 
    end 
#*********************Signing Up - Logging In*******************>
    
    def user_signing_up#works
        # OrderHere.header
        user_signing = User.register
        until user_signing  
            user_logged = User.register
        end 
        self.user = user_signing
        system "clear"
        self.main_menu
    end 

    def user_logging_in   
        system "clear"
        OrderHere.header
        username = TTY::Prompt.new.ask("Enter your username")
        #check if the username exist on database
        potential_user = User.all.find {|name| name.name == username }
        # def existing_user 
        if User.all.exclude?(potential_user)
            puts "We didn't find #{username} in our database"
            sleep(2)
            self.wrong_user_name  
        else 
            puts "Welcome back #{username} "
            sleep(1)
        end 
        potential_user
        self.user = potential_user
        self.main_menu
    end

    def wrong_user_name 
        system 'clear'
        OrderHere.header
        prompt.select("Do you want to try again?") do |menu|
            menu.choice "yes", ->{user_logging_in}
            menu.choice "No", ->{choose_login_or_signup}
        end 
    end

##**************************Quit App**********************************>

    def quit_app #Done
        exit!
    end

###**************************Main menu********************************>

    def main_menu #Done
        system "clear"
        OrderHere.header
        puts "<******************************||".colorize(:green)
        puts "    ~~~ M A I N - M E N U ~~~    ".colorize(:blue)
        puts "||******************************>".colorize(:green)
        puts ""
        puts " Welcome to the menu ~ #{self.user.name} ~ "
        puts ""
        prompt.select("What would you like to do") do |menu|
            menu.choice "Manage Profile", -> {profile_setup}
            menu.choice "Start My Order", -> {display_all_restaurants}
            menu.choice "Last Dish ordered", ->{user_dishes_history}
            menu.choice "Exit", -> {choose_login_or_signup}
        end
    end 

    def profile_setup #Done
        system 'clear'
        OrderHere.header
        puts "This Is ~ #{self.user.name} ~ Profile"
        @prompt.select("~~ M Y - P R O F I L E ~~") do |menu|
            menu.choice "Update Username", -> {change_username_prompt}
            menu.choice "Update Password", -> {change_password_prompt}
            menu.choice "Delete Account", -> {delete_profile_prompt}
            menu.choice "Sign out", -> {sign_out_prompt}#added exit option
            menu.choice "Back", -> {main_menu}
        end
        sleep 1
    end

#************************ List of all Restaurants *********************>

    def display_all_restaurants
        user.reload
        system "clear"
        OrderHere.header
        # clear previous cart if any
        user.dishes.each {|dish| dish.destroy }
        pick_a_restaurant = prompt.select(" Please choose a restaurant to start your order", Restaurant.list)
        @choosen_restaurant = Restaurant.find(pick_a_restaurant)
        #----Dishes for the curent user --------
        system 'clear'
        OrderHere.header
        chosen_dish = prompt.select("Choose your dish" ,Dish.all_dishes )
        #___Create a new Order using the options from the current user ______
        Order.create(user_id: self.user.id, dish_id: chosen_dish, restaurant_id: @choosen_restaurant)
        self.order_menu
    end 

#************************************** Order Menu  *******************************>

    def order_menu
        user.reload
        puts " #{self.user.name} you have completed your order"
        system 'clear'
        OrderHere.header
        puts "Your current cart" 
        puts " #{user_dishes_names}"  
        prompt.select("Would you like to add another dish?") do |menu|      
            menu.choice "Yes Please", -> {continue_with_order}
            menu.choice "No I am done", -> {review_my_cart_0}
        end 
    end 


#************************ Continue with your order  ****************************>

    def continue_order_menu
        user.reload
        puts " #{self.user.name} You have completed your order"
        system 'clear'
        OrderHere.header
        puts "Your current cart"
        puts " #{user_dishes_names}"
        prompt.select("Would you like to add another dish?") do |menu|
            menu.choice "Yes Please", -> {continue_with_order}
            menu.choice "No I am done", -> {cart_checkout}
        end 
    end 

#************************* Continue adding to the order  *************************>

    def continue_with_order
        user.reload
        system 'clear'
        OrderHere.header
        puts ""
        puts "Your current cart"
        puts " #{user_dishes_names}"
        puts ""
        
        # puts "You are here #{user_dishes_names}"
        choosen_restaurant = choosen_restaurant
        chosen_dish = prompt.select("Choose your next dish" ,Dish.all_dishes )
        
        Order.create(user_id: self.user.id, dish_id: chosen_dish, restaurant_id: choosen_restaurant)
        self.continue_order_menu
    end 

#************************* Cart Menu **********************************>

    def cart_checkout
        user.reload
        system "clear"
        OrderHere.header
        puts "#{self.user.name} this is your current cart"
        puts "#{user_dishes_names}"
        prompt.select("Lets go to to your cart") do |menu|
            menu.choice "No, I would like to add another dish", -> {continue_with_order}
            menu.choice "Sure, view my cart", -> {review_my_cart_0}
        end
        
    end 

# ***************** Review My Cart ***********************************

    def review_my_cart_0
        user.reload
        system "clear"  
        OrderHere.header
        dishes = user.dishes.map(&:id)
        dishes_hash = user.dishes.map do |dish|
        { "#{dish.dish_name}  $#{dish.dish_price}" => dish.id }
        end  
        #------Reviewing my cart and choosing to remove dishes if I want to-------------- 
        system 'clear'
        OrderHere.header
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
        proceed_to_checkout = prompt.yes?("The order looks good, go to checkout")
        # USER IS HAPPY WITH THE ORDER, READY TO CHECKOUT
        if proceed_to_checkout
            review_my_cart 
        end
        cart = prompt.select("Review your cart" ,dishes_hash )
        remove_a_dish = prompt.yes?("Would you like to remove this dish?")
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
        OrderHere.header

        # ------------new array of dishes after the deletion----------------------
        dishes_hash_2 = user.dishes.map do |dish|
            { "#{dish.dish_name}  $#{dish.dish_price}" => dish.id }
        end  
        cart = prompt.select("Would you like to remove a dish?" ,dishes_hash_2 )
        prompt.yes?("Remove this dish?")
        # getting the name of the dish 
        Order.find(cart).destroy
        Dish.find(cart).destroy
        # binding.pry
        prompt.select("Would you like to remove another dish?") do |menu|
            menu.choice "Yes", -> {continue_removing}
            menu.choice "No, I am ready to checkout", -> {review_my_cart}
        end
    end 

#********************review my cart **********************************>

    def review_my_cart
        user.reload
        system "clear"
        OrderHere.header

        # ------ HELPER METHODS FOR THE CART -----------------------
        # -----mapping the dishes into a hash
        dishes_hash = user.dishes.map do |dish|
            "#{dish.dish_name} $#{dish.dish_price}"
        end  
        # ------grouping dishes by name
        group_the_dishes = dishes_hash.group_by { |dish_name| dish_name} 
        dishes_grouped_by_name = group_the_dishes.map { |dish_name, dish_price| "  #{dish_price.size} ............. #{dish_name}" }
        # -------mathematical logic fo the receipt 
        subtotal = user.dishes.sum(&:dish_price)
        tax = subtotal*0.08
        total = subtotal + tax
        gratuity = subtotal * 0.2
        # ----------------BODY OF THE RECEIPT-------------------------------------
        system "clear"
        OrderHere.go

        sleep 0.5
        OrderHere.header
        puts " "
        puts "       🥗🍜😁Welcome to FOODIES😁🍜🥗   " 
        puts "    We are located in the Avatar Kingdom "
        puts "          www.TheCodeBenders.com"
        puts " "
        puts "              #{@choosen_restaurant.name.upcase} Restaurant".colorize(:yellow)
        puts "           is in charge of your order"
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
        puts ""
        puts '----------------------------------------------'
        puts "      We appreciate your bussiness"
        puts "             #{self.user.name}".colorize(:yellow)
        puts "         Please come again"
        puts "
        "
        prompt.select("We hope you enjoy your order") do |menu|
            puts ""
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Place another order", -> {display_all_restaurants}
            menu.choice "Quit the app", -> {quit_app}
        end
    end 

    # ____________________________________________________________________
    
    def user_dishes_history
        user.reload
        system 'clear'
        OrderHere.header 
        
        # Note: I could show dishes in all history, but since I am seeding the dishes with Faker gem, 
        # everytime I place a new order, I only have access to those dishes Id. - Scope problem -
        # orders_id = user.orders.map(&:id)
        # binding.pry
        orders_id = user.dishes.map(&:id)
        dishes_id = Dish.find(orders_id)
        dish_array = dishes_id.map {|dish| "#{dish.dish_name} -- $#{dish.dish_price}"}
        
        if user.orders.count > 0            
            last_dish = prompt.select(" Dishes you have ordered before", dish_array)
        else 
            puts "Your history is empty"
        sleep (2)
        end 
        self.main_menu
    end 


#--------------------HELPER METHOD -------------------------------------->

    def user_dishes_names
        user.dishes.map do |dish|
            "#{dish.dish_name} - $#{dish.dish_price} "
        end 
    end 

####***********************Updating Porfile Infos********************************>
    #*************Updating Username*************>

    def change_username_prompt#Works
        system 'clear'
        OrderHere.header
        prompt.select("Please confirm you are editing your username") do |menu|
            menu.choice "Yes", -> {change_username}
            menu.choice "No", -> {profile_setup}
        end
    end

    def change_username
        system "clear"
        OrderHere.header
        new_username = @prompt.ask("Enter a new username", required: true)
        self.user.update_attribute(:name, new_username)
        puts "Your username has been updated!"
        sleep 1.5
        profile_setup
    end

    #************Updating Password***************>

    def change_password_prompt #Done
        system 'clear'
        OrderHere.header
        prompt.select("Please confirm you are editing your password") do |menu|
            menu.choice "Yes", -> {change_password}
            menu.choice "No", -> {profile_setup}
        end
    end

    def change_password #Done
        system "clear"
        OrderHere.header
        new_password = @prompt.mask("Enter a new password", required: true)
        self.user.update_attribute(:password, new_password)
        system "clear"
        puts "Your password has been updated!"
        sleep 1.5
        profile_setup
    end
    #*****************Deleting***************>

    def delete_profile_prompt #Done
        system 'clear'
        OrderHere.header
        prompt.select("Are you sure you want to delete your profile?") do |menu|
            menu.choice "Yes", -> {delete_profile}
            menu.choice "No", -> {profile_setup}
        end
    end

    def delete_profile #Done
        self.user.delete
        system 'clear'
        OrderHere.header
        puts "You've succesfully deleted your profile"
        sleep 1
        puts "Sorry to see you leave"
        sleep 2
        choose_login_or_signup#We can do delete or completely exit the app with #quit_app
    end 

    #*****************Logout***************>
    def sign_out_prompt #Done
        system 'clear'
        OrderHere.header
        prompt.select("Are you sure you want to sign out?") do |menu|
            menu.choice "Yes", -> {sign_out}
            menu.choice "No", -> {profile_setup}
        end
    end

    def sign_out #Done
        system "clear"
        OrderHere.header
        puts ""
        puts "Thank you for ordering with Foodies"
        sleep 1
        puts "You're now logged out"
        sleep 1 
        choose_login_or_signup# exit! will exit the CLI app totally
    end

end
