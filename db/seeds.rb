# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Clearing existing data..."
Booking.destroy_all
Court.destroy_all
User.destroy_all

puts "Creating Users..."
users = [
  User.create!(name: "Sarah J."),
  User.create!(name: "R. Smith"),
  User.create!(name: "J. Doe"),
  User.create!(name: "L. Chen"),
]

puts "Creating Courts..."
courts = [
  Court.create!(name: "Court 1")
]

puts "Creating Bookings..."
# Create bookings for today and tomorrow
today = Date.today

# Sarah's bookings
Booking.create!(user: users[0], court: courts[0], time: today.to_time + 9.hours)
Booking.create!(user: users[0], court: courts[1], time: today.to_time + 14.hours)

# Smith's bookings
Booking.create!(user: users[1], court: courts[0], time: today.to_time + 10.hours)
Booking.create!(user: users[1], court: courts[1], time: (today + 1.day).to_time + 10.hours)

# Doe's bookings
Booking.create!(user: users[2], court: courts[2], time: today.to_time + 18.hours)
Booking.create!(user: users[2], court: courts[2], time: (today + 1.day).to_time + 9.hours)

puts "Seed finished! Created #{User.count} users, #{Court.count} courts, and #{Booking.count} bookings."
