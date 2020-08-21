<h1>FOODIES CLI APP</h1>

"FOODIES" is a CLI application that allows users to place orders at restaurants. Users are able to create, login, and manage their account, place an order with a restaurant, and checkout.

The app features a welcome display which prompt users to login, or sign up for a new account. The users are then taken to the main menu where the options are to manage their account, place an order, or exit the app.

The application is pre-seeded with dummy data of restauraunts and associated dishes with the help
of the 'faker' gem. User can select the 'Start My Order' option form the main menu, which shows them a list of restaurants they can choose from. The user can then select the dish they would like to order, with the option to delete some items when reviweing the order or proceed to checkout and complete the order. Once the order completed, the user has the option to exit the app, place a new order, or simply exit the app.

This app was developed for Flatiron School’s mod1 pairing project to demonstrate the knowledge of Active Record Associations, as well as CRUD(Create, Read, Update, Delete) methods, and database management.


<h4>HOW TO GET STARTED</h4>

1. Clone this repository to your computer.
2. In your computer terminal, CD into the directory of this repository.
3. Run 'bundle install' to install all the gems required for the app to load.
4. Run 'rake db:migrate' to create the required database tables.
5. Run 'rake db:migrate:status' to make sure the tables were created.
6. Run 'rake db:seed' to seed your table(dummy seeds created with 'faker' gem). 
7. Run 'rake start' to start the app 
8. Enjoy the app 😁


<H4>HOW TO USE THE APP</H4>

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
        - before checking out the user have the possibility to delete items selected or checkout 
        - after checkout the user will see a receipt with all the oders placed,the total amount of their purchase, and be prompted to go back to the main menu, place another order, or leave the app
   - The option to exit the app

<h3>Creators</h3>

Franklin Bado https://github.com/fbado66<br>
Samir Triande https://github.com/mirsafirst47