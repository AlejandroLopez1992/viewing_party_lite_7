# frozen_string_literal: true

require 'rails_helper'

describe 'user result show page', :vcr do
  before :each do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user2 = User.create!(name: 'JaJa', email: 'JaJa@hotmail.com', password: 'password123', password_confirmation: 'password123')
  
    @movie1 = SearchFacade.new({ type: 'top_rated' }).movies.first
    @movie2 = SearchFacade.new({ type: 'top_rated' }).movies[10]
    @new_movie1 = SearchFacade.new({ id: "#{@movie1.id}" }).movies
  end

  it 'has button to create a viewing party' do
    visit user_discover_index_path(@user1)
    click_on "Top Rated"
    click_on "The Godfather"
    expect(page).to have_button("Create a Viewing Party!")
    click_button "Create a Viewing Party!"
    expect(current_path).to eq(new_user_movie_viewing_party_path(@user1, @movie1.id))
  end

  it 'has a button to return to the discover page' do
    visit user_movie_path(@user1, @movie1.id)
    expect(page).to have_button('Return to Discover')
    click_on('Return to Discover')
    expect(current_path).to eq(user_discover_index_path(@user1))
  end

  describe 'movie information' do
    before :each do
      visit user_movie_path(@user1, @new_movie1.id)
    end
    it 'has movie title' do
      expect(page).to have_content(@movie1.title)
      expect(page).to have_no_content(@movie2.title)
    end

    it 'has vote average of movie' do
      expect(page).to have_content(@movie1.vote_average)
      expect(page).to have_no_content(@movie2.vote_average)
    end

    it 'has runtime in hours and minutes' do
      expect(page).to have_content(@new_movie1.runtime)
      expect(@new_movie1.runtime).to eq("2 hours, 55 minutes")
    end

    it 'has genres for movie' do
      expect(page).to have_content(@new_movie1.genres)
      expect(@new_movie1.genres).to eq("Drama, Crime")
    end

    it 'has a summary' do
      expect(page).to have_content(@new_movie1.summary)
      expect(@new_movie1.summary).to eq("Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.")
    end

    it 'lists first 10 cast members' do
      visit user_movie_path(@user1, @new_movie1.id)
      within "#member_#{@new_movie1.cast.first[:cast_id]}" do
        expect(page).to have_content("Al Pacino as Michael Corleone")
      end
      expect(@new_movie1.cast.count).to eq(10)
    end

    it 'has count of total reviews' do
      visit user_movie_path(@user1, @new_movie1.id)
      expect(page).to have_content(@new_movie1.review_count)
      expect(@new_movie1.review_count).to eq(3)
    end

    it 'has each reviews author and info' do
      visit user_movie_path(@user1, @new_movie1.id)
      expect(page).to have_content("crastana Review:")
      expect(page).to have_content("futuretv Review:")
      expect(page).to have_content("drystyx Review:")
    end
  end
end