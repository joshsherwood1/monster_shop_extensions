# Monster Shop Extensions
BE Mod 2 Week 6 Individual Project

This application uses:
- Ruby 2.4.1
- Rails 5.1.7


## Background and Description
In this project, I added additional functionalities to an existing repo ([original monster_shop](https://github.com/joshsherwood1/monster_shop) built with Rails).

Monster Shop a fictitious e-commerce platform and allows different types of users can log in and have access to different functionality. All user types have access to certain CRUD functionality for different resources. For example, regular users can add items to the cart, create orders, and cancel orders; admin users can enable and disable merchants and their items and ship orders that have been packaged. Ruby on Rails framework is used to build the application. ActiveRecord is used to make database inquiries. PostgreSQL is used to build the database.


## Required functionalities
The project demonstrates the following concepts:

- HTTP requests and responses facilitated by RESTful and non-RESTful routes
- Separation of logic via MVC framework
- Create one-to-many & many-to-many relationships between two tables
- Use grouping and aggregate functions with SQL and ActiveRecord to obtain specific information from database
- Use authentication and authorization to verify users and give certain users access to certain functionality
- Registered users have one or more addresses associated with their profile and need an address to check out
- Address can be changed on order page after order has been placed until an admin has shipped an order

Below is a snapshot of the project database via active designer (showing different types of relationships)

![active_designer](https://user-images.githubusercontent.com/49769068/66280140-d1951600-e8a4-11e9-81b1-fca1c3831bf7.png)


## Additional functionalities

- Coupon management center allows merchant users CRUD functionality for coupons with discounts based on a percentage or dollar amount
- Functionality regarding adding coupons to user orders is still in progress

## Website
   View the project at https://boiling-brook-97690.herokuapp.com/
   
   - To log in as a regular user, simply register for a new account or use username: 5@gmail.com & password: password
   - To log in as a merchant user, use username: 7@gmail.com & password: password
   - To log in as an admin user, use username: 8@gmail.com & password: password
