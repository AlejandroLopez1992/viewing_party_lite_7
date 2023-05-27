# frozen_string_literal: true

require 'rails_helper'

describe 'user dashboard', :vcr do
  before :each do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    visit login_path

    fill_in(:name, with: @user1.name)
    fill_in(:password, with: @user1.password)
    click_button("Log In")

    @user2 = User.create!(name: 'Donald J Trump', email: 'Trumpinator420@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @movie1 = SearchFacade.new({ id: "238" }).movies
  end

  it 'has application title' do
    expect(page).to have_content('Viewing Party')
  end

  it 'has user name dashboard title' do
    
    expect(page).to have_content("#{@user1.name} Dashboard")
  end

  describe 'discover movies' do
    it 'has a discover movies button' do
      expect(page).to have_button('Discover Movies')
    end

    it 'clicking button redirects to users/:id/discover page' do

      click_button('Discover Movies')
      expect(current_path).to eq("/users/#{@user1.id}/discover")
    end
  end

  it 'has viewing party attributes on host section' do
    visit new_user_movie_viewing_party_path(@user1, @movie1.id)
    
    fill_in('Duration', with: 176)
    select "2024", from: '[date(1i)]'
    select "May", from: '[date(2i)]'
    select "5", from: '[date(3i)]'
    select "00", from: '[time(4i)]'
    select "00", from: '[time(5i)]'
    within "#user_#{@user2.id}" do
    check
  end
  click_on "Create Party"
  
  viewing_party = ViewingParty.last

    within "#hosted" do
      expect(page).to have_content("#{@movie1.title} Viewing Party")
      expect(page).to have_content(viewing_party.date)
      expect(page).to have_content(viewing_party.time)
      expect(page).to have_content("You are the host of this party")
      expect(page).to have_content("Donald J Trump")
    end
  end

  it 'has viewing party attributes on invitee section' do
    visit new_user_movie_viewing_party_path(@user1, @movie1.id)
    
    fill_in('Duration', with: 176)
    select "2024", from: '[date(1i)]'
    select "May", from: '[date(2i)]'
    select "5", from: '[date(3i)]'
    select "00", from: '[time(4i)]'
    select "00", from: '[time(5i)]'
    within "#user_#{@user2.id}" do
      check
    end
    click_on "Create Party"

    viewing_party = ViewingParty.last

    visit dashboard_path
    
    within "#hosted" do
      expect(page).to have_content("#{@movie1.title} Viewing Party")
      expect(page).to have_content(viewing_party.date)
      expect(page).to have_content(viewing_party.time)
      expect(page).to have_content("You are the host of this party")
    end

    visit dashboard_path

    within "#invited" do
      expect(page).to have_no_content("#{@movie1.title} Viewing Party")
    end
  end

  it 'has movie image for movie that viewing party is associated with' do
    visit new_user_movie_viewing_party_path(@user1, @movie1.id)
    
    fill_in('Duration', with: 176)
    select "2024", from: '[date(1i)]'
    select "May", from: '[date(2i)]'
    select "5", from: '[date(3i)]'
    select "00", from: '[time(4i)]'
    select "00", from: '[time(5i)]'
    within "#user_#{@user2.id}" do
      check
    end
    click_on "Create Party"

    expect(@movie1.poster_path).to eq("/3bhkrj58Vtu7enYsRolD1fZdja1.jpg")
  end
end
