# frozen_string_literal: true

require 'rails_helper'

describe 'user discover page' do
  before :each do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user2 = User.create!(name: 'JaJa', email: 'JaJa@hotmail.com', password: 'password123', password_confirmation: 'password123')

    visit user_discover_index_path(@user1)
  end

  it 'has Top Rated Movies button', :vcr do
    expect(page).to have_button('Top Rated Movies')
    click_button('Top Rated Movies')
    expect(current_path).to eq(user_movies_path(@user1))
  end

  it 'has search feature to search movies by title' do
    expect(page).to have_content('Search movies by title')
  end

  it 'has button to submit search by title' do
    expect(page).to have_button('Search')
  end

  it 'redirects to results page', :vcr do
    fill_in 'title', with: 'gods'
    click_button('Search')
    expect(current_path).to eq(user_movies_path(@user1))
    expect(page).to have_content('God', count: 20)
  end

  it 'provides flash error and redirects to same page if input is less than 1 charater', :vcr do
    visit user_discover_index_path(@user1)

    fill_in 'title', with: ''
    click_button('Search')
    expect(current_path).to eq(user_discover_index_path(@user1))
    expect(page).to have_content('Error: Input must be at least 1 charachter')
  end
end
