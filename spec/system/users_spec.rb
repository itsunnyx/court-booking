require 'rails_helper'

RSpec.describe 'User features', type: :system do
  it 'allows a user to add credits' do
    User.create!(name: "Test User", credit: 0)
    
    visit root_path
    click_button "Login"
    
    # Check that initial credit is 0
    expect(page).to have_content('Credits: 0')
    
    # Click Add Credit button
    click_button 'Add Credit'
    
    # Fill in the amount in the modal
    within('#add_credit_modal') do
      fill_in 'amount', with: '50'
      click_button 'Add'
    end
    
    # Check for success message and updated credits
    expect(page).to have_content('Credits successfully added!')
    expect(page).to have_content('Credits: 50')
  end
end
