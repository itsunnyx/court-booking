require 'rails_helper'

RSpec.describe 'Booking flow', type: :system do
  it 'allows a user to book an available court slot' do
    user = User.create!(name: "Test User")
    court = Court.create!(name: "Test Court 1")
    
    visit root_path
      click_button 'Login'
    
    # Find the first "Book Now" link and click it
    first('a', text: 'Book Now').click
    
    # Verify we are on the confirmation page
    expect(page).to have_content("Confirm Booking")
    expect(page).to have_content("Test Court 1")
    
    # Confirm the booking
    click_button 'Confirm Booking'
    
    # Verify we are redirected back with a success message
    expect(page).to have_content('Booking was successfully created.')
    
    # The slot should now show as booked
    expect(page).to have_content('Cancel Booking')
  end

  it 'allows a user to cancel their own booking' do
    user = User.create!(name: "Test User")
    court = Court.create!(name: "Test Court 1")
    booking = Booking.create!(user: user, court: court, time: Time.zone.now.beginning_of_day + 10.hours)
    
    visit root_path(date: Time.zone.now.to_date)
      click_button 'Login'
    
    # We should see the booking
    expect(page).to have_content('Cancel Booking')
    
    # Click Cancel
    click_link 'Cancel Booking'
    
    # Verify we are on the cancellation confirmation page
    expect(page).to have_content("Confirm Cancellation")
    expect(page).to have_content("Test Court 1")
    
    # Confirm the cancellation
    click_button 'Confirm Cancellation'
    
    expect(page).to have_content('Booking was successfully cancelled.')
    expect(page).to have_content('Book Now')
  end
end
