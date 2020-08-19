class Interface
    attr_reader :prompt
    attr_accessor :user, :restaurant, :order, :dish

    def initialize#Works
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

    def display_all_restaurants#works
        choosen_restaurant_id = prompt.select("Choose a Restaurant to start your order" ,Restaurant.list)
        
        choosen_restaurant = Restaurant.find(choosen_restaurant_id)
        dishes = choosen_restaurant.dishes
        dishes
        prompt.select("Choose your dish" ,Dish.all_dishes)
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
