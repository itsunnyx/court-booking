require 'rails_helper'

RSpec.describe 'Home page', type: :system do
  it 'displays the dashboard with courts, time slots, and availability' do
    user = User.create!(name: "Test User")
    court = Court.create!(name: "Test Court 1")
    
    # Create booking for 9:00 AM today
    booking_time = Time.zone.now.beginning_of_day + 9.hours
    Booking.create!(user: user, court: court, time: booking_time)
    
    visit root_path
    
    expect(page).to have_content('ODT Booking')
    expect(page).to have_content('Test Court 1')
    
    # Check that time range is formatted correctly
    expect(page).to have_content('09:00-10:00')
    
    # The booked slot should show as Cancel Booking
    expect(page).to have_content('Cancel Booking')
    
    # An empty slot should show as Book Now (e.g. 6 AM)
    expect(page).to have_content('06:00-07:00')
    expect(page).to have_content('Book Now')
  end

  it 'displays a dynamic calendar showing the current month and booking indicators' do
    user = User.create!(name: "Test User")
    court = Court.create!(name: "Test Court 1")
    
    # Booking tomorrow
    booking_time = Time.zone.now.beginning_of_day + 1.day + 10.hours
    Booking.create!(user: user, court: court, time: booking_time)
    
    visit root_path
    
    expect(page).to have_content('ODT Booking')
    expect(page).to have_content('Logged in as Test User')
    
    # Calendar header should show current month and year
    expect(page).to have_content(Time.zone.now.strftime("%B %Y"))
  end

  it 'allows clicking a future date on the calendar to view and book slots for that date' do
    User.create!(name: "Test User")
    Court.create!(name: "Test Court 1")
    
    visit root_path
    
    tomorrow = (Time.zone.now + 1.day).to_date
    
    # We find the day cell in the calendar and click it
    find(".calendar-day-#{tomorrow.strftime('%Y-%m-%d')}").click
    
    # The calendar month should still be correct
    expect(page).to have_content(tomorrow.strftime("%B %Y"))
    
    # The Book Now buttons should have the new date
    expect(page).to have_css("a[href*='date=#{tomorrow.to_s}']")
    
    # The Book Now button should pass the correct date parameter
    # We test this implicitly by clicking Book Now and checking the confirm page
    first('a', text: 'Book Now').click
    expect(page).to have_content("Date: #{tomorrow.strftime('%A, %b %d, %Y')}")
  end

  it 'allows switching to the next month' do
    User.create!(name: "Test User")
    
    visit root_path
    
    next_month = (Time.zone.now + 1.month).beginning_of_month.to_date
    
    # Click the next month arrow
    click_link '→'
    
    # Calendar header should show next month and year
    expect(page).to have_content(next_month.strftime("%B %Y"))
  end
end
