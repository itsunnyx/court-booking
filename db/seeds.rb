# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Clearing existing data..."
CourtDeactivation.destroy_all
Booking.destroy_all
Court.destroy_all
User.destroy_all

puts "Creating Courts..."
courts = [
  Court.create!(name: "Court 1")
]

puts "Creating Users..."
users = [
  User.create!(name: "Sarah J."),
  User.create!(name: "R. Smith"),
  User.create!(name: "J. Doe"),
  User.create!(name: "L. Chen"),
]

puts "Seed finished! Created #{User.count} users, #{Court.count} courts, and #{Booking.count} bookings."
