# frozen_string_literal: true

require 'rails_helper'

describe 'user results page', :vcr do
  before :each do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user2 = User.create!(name: 'JaJa', email: 'JaJa@hotmail.com', password: 'password123', password_confirmation: 'password123')

    visit user_discover_index_path(@user1)
  end

  it 'has Top Rated Movies results with correct attributes', :vcr do
    @movie1 = SearchFacade.new({ type: 'top_rated' }).movies.first
    expect(page).to have_button('Top Rated Movies')
    click_button('Top Rated Movies')
    expect(current_path).to eq(user_movies_path(@user1))
    within("#movie-#{@movie1.id}") do
      expect(page).to have_content(@movie1.title)
      expect(page).to have_content(@movie1.vote_average)
    end
  end

  it 'has returnt to discover page button' do
    click_button('Top Rated Movies')
    expect(page).to have_button('Return to Discover')
    click_on('Return to Discover')
    expect(current_path).to eq(user_discover_index_path(@user1))
  end
end
