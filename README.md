FOODIES CLI APP


HOW TO GET STARTED

1. Clone this repository to your computer.
2. In your computer terminal, CD into the directory of this repository.
3. Run 'bundle install' to install all the gems required for the app to load.
4. Run 'rake db:migrate' to create the required database tables.
5. Run 'rake db:migrate:status' to make sure the tables were created.
6. Run 'rake db:seed' to seed your table(dummy seed created with 'faker' gem). 
7. Run 'ruby bin/run.rb' to start the app 
8. Enjoy the app 😁



HOW TO USE THE APP

1. Upon launching the application, the user will be prompted to login or sign up for a new account.
2. For returning users, welcome back, and follow the login steps and enjoy the app.
3. For new users, we're glad to have you. Follow the the steps to signing up. 
4. After creating an account or logging in, the user will be directed into a main menu page.
5. The menu page has three part
   - Manage Profile where a user can see their profile and
        - update their username
        - update their password
        - delete their account
        - sign out or go back to the main menu
   - Start My Order when ready to place an order
        - see the list of all restaurants available
        - select a restaurant and see the full menu of that specific restaurant
        - select from the menu the dish(es) they would like to add  to the cart
        - review the the selcted dish(es) with option to add more or go to checkout
        - before checking out the user have the possibility to delete items selcted or checkout 
        - after checkout the user will see a receipt with all the oders placed,the total amount of their puschase, and be prompted to go back to the main menu, place another order, or leave tha app
   - The option to exit the app


 