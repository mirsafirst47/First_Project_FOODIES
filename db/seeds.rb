require 'faker'

# User.destroy_all
# Order.destroy_all
Dish.destroy_all
Restaurant.destroy_all

# 25.times do 
#     User.create(
#         name: Faker::Name.unique.name,
#         password: Faker::String.random(length: 4)
#     )
# end

# 25.times do
#     Order.create(
#         user_id: Faker::Number.within(range: 1..25),
#         dish_id: Faker::Number.within(range: 1..25),
#         restaurant_id: Faker::Number.within(range: 1..25)
#     )
# end

100.times do
    Dish.create(
        dish_name: Faker::Food.dish,
        dish_price: Faker::Commerce.price(range: 0..15.0, as_string: true),  
        restaurant_id: Faker::Number.within(range: 1..10)
    )
end

10.times do
    Restaurant.create(
        name: Faker::Restaurant.unique.name
    )
end

puts "Data Seeded"
