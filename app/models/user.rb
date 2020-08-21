class User < ActiveRecord::Base
    
    has_many :orders
    has_many :dishes, through: :orders
    has_many :restaurants, through: :orders

    def self.register
        system "clear"
        OrderHere.header
        userInfo = TTY::Prompt.new.ask("Create your username?")
        passwordInfo = TTY::Prompt.new.mask("Enter a password?")
        if User.find_by(name: userInfo)
            puts "Sorry, the username #{userInfo} is already taken."
        else 
            User.create(name: userInfo, password: passwordInfo)
        end 
    end 

end

   