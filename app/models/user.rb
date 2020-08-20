class User < ActiveRecord::Base
    
    has_many :orders
    has_many :dishes, through: :orders
    has_many :restaurants, through: :orders

    def self.register
        system "clear"
        userInfo = TTY::Prompt.new.ask("Create your username?")
        passwordInfo = TTY::Prompt.new.mask("Enter a password?")
        if User.find_by(name: userInfo)
            puts "Sorry, the username #{userInfo} is already taken."
        else 
            User.create(name: userInfo, password: passwordInfo)
        end 
    end 

end

    # def self.existing_user 
    #     system "clear"
    #     username = TTY::Prompt.new.ask("Enter your username")
    #     #check if the username exist on database
    #    potential_user = User.all.find {|name| name.name == username }
    # #    binding.pry
        
    #     if User.all.exclude?(potential_user)
    #         puts "#{username} not found in database"
    #         sleep(2)
    #         Interface.user_signing_up   
    #         # end 
    #         # Interface.quit_app


    #     else 
        
    #         puts " #{username} You are in"
    #         potential_user
    #         # binding.pry
    #         sleep(1)
        
    #     end 
    #     potential_user
    # end

