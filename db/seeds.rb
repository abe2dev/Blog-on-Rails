# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# First destroy all records from table comments due to FK constraint.
# Then destroy all records from table posts.
Comment.destroy_all
Post.destroy_all
User.destroy_all 

# Reset the primary key sequence to 1.
ActiveRecord::Base.connection.reset_pk_sequence!(:posts)
ActiveRecord::Base.connection.reset_pk_sequence!(:comments)
ActiveRecord::Base.connection.reset_pk_sequence!(:users)

PASSWORD = '123'
User.create( 
  name: "Ibrahim",
  email: 'abe@gmail.com',
  password: PASSWORD
)

5.times do |n|
  User.create(
    name: Faker::Name.first_name,
    email: "user#{n + 1}@user.com",
    password: PASSWORD
  )
end

users = User.all.offset 1
puts Cowsay.say("Generated #{users.count} users using Faker.", :tux)

  # Bulk insert of 50 fake posts.
  Post.insert_all(
    50.times.map do
      {
        title: Faker::Hacker.say_something_smart,
        body: Faker::ChuckNorris.fact,
        user_id: users.sample.id,
        created_at: Faker::Time.backward(days: 365),
        updated_at: DateTime.now
      }
    end
  )
  
  # Show how many fake posts are in the table posts.
  puts Cowsay.say("Generated #{Post.count} posts using Faker.", :frogs)
