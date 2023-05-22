# frozen_string_literal: true

require 'rails_helper'

describe 'create user' do
  before :each do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user2 = User.create!(name: 'JaJa', email: 'JaJa@hotmail.com', password: 'password123', password_confirmation: 'password123')
    visit '/register'
  end

  it 'has application title' do
    expect(page).to have_content('Viewing Party')
  end

  it 'has working registration form' do
    fill_in :name, with: 'Jane'
    fill_in :email, with: 'Its_Jane_Doe@yahoo.com'
    fill_in :password, with: "Janeiscool1"
    fill_in :password_confirmation, with: "Janeiscool1"

    click_button 'Register'

    user = User.last
    expect(user).to_not have_attribute(:password)
    expect(user.password_digest).to_not eq('Janeiscool1')
    expect(user.name).to eq('Jane')
    expect(current_path).to eq(user_path(user))
  end

  it "name missing missing passoword, or matching passwords are matching, redirect to /register" do
    fill_in :name, with: ''
    fill_in :email, with: 'Its_Jane_Doe@yahoo.com'
    fill_in :password, with: "Janeiscool1"
    fill_in :password_confirmation, with: "Janeiscool1"

    click_button 'Register'

    expect(current_path).to eq(new_user_path)
    expect(page).to have_content("Error: Name can't be blank")

    fill_in :name, with: 'Jane'
    fill_in :email, with: 'Its_Jane_Doe@yahoo.com'
    fill_in :password, with: ""
    fill_in :password_confirmation, with: "Janeiscool1"

    click_button 'Register'

    expect(current_path).to eq(new_user_path)
    expect(page).to have_content("Error: Password can't be blank, Password digest can't be blank")

    fill_in :name, with: 'Jane'
    fill_in :email, with: 'Its_Jane_Doe@yahoo.com'
    fill_in :password, with: "ApplewoodBacon393"
    fill_in :password_confirmation, with: "Janeiscool1"
    click_button 'Register'

    expect(current_path).to eq(new_user_path)
    
    expect(page).to have_content("Error: Password confirmation doesn't match Password")
  end

  it 'wont allow duplicate email' do
    fill_in :name, with: 'Adam'
    fill_in :email, with: 'JoJo@hotmail.com'
    fill_in :password, with: "Janeiscool1"
    fill_in :password_confirmation, with: "Janeiscool1"

    click_button 'Register'
    expect(User.last.name).to eq('JaJa')
    expect(current_path).to eq(new_user_path)
    within '#flash_message' do
      expect(page).to have_content('Error: Email has already been taken')
    end
  end

  it 'wont allow case insensitive email duplicate' do
    fill_in :name, with: 'Adam'
    fill_in :email, with: 'jojo@hotmail.com'
    fill_in :password, with: "Janeiscool1"
    fill_in :password_confirmation, with: "Janeiscool1"

    click_button 'Register'
    expect(User.last.name).to eq('JaJa')
    expect(current_path).to eq(new_user_path)
    within '#flash_message' do
      expect(page).to have_content('Error: Email has already been taken')
    end
  end
end
