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


    # def self.existing_user 
    #     system "clear"
    #     username = TTY::Prompt.new.ask("Enter your username")

    #     #check if the username exist on database
    #     if User.all.map(&:username).exclude?(username)
    #         puts "#{username} not found in database"
    #         system "clear"
    #     end

    #     # if user is found 
    #     self.user = username
    # end 

end