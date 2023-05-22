require 'rails_helper'

RSpec.describe "Logging In" do
  it "can log in with valid credentials" do
    user = User.create!(name: "meg", email:"meg@test.com", password: "test123", password_confirmation: "test123")
    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :name, with: user.name
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(user_path(user))

    expect(page).to have_content("Welcome, #{user.name}")
  end

  it "cannot log in with bad credentials" do
    user = User.create!(name: "meg", email:"meg@test.com", password: "test123", password_confirmation: "test123")
  
    visit login_path
    
    fill_in :name, with: user.name
    fill_in :password, with: "incorrect password"
  
    click_on "Log In"
  
    expect(current_path).to eq(login_path)
  
    expect(page).to have_content("Sorry, your credentials are bad.")

    fill_in :name, with: "Brocolli"
    fill_in :password, with: "test123"

    click_on "Log In"
  
    expect(current_path).to eq(login_path)
  
    expect(page).to have_content("Sorry, your credentials are bad.")
  end
end