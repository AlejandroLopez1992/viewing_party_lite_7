
require 'rails_helper'

describe 'new viewing party', :vcr do
  before :each do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user2 = User.create!(name: 'JaJa', email: 'JaJa@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user3 = User.create!(name: 'Donald J Trump', email: 'Trumpinator420@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @movie1 = SearchFacade.new({ id: "238" }).movies

    visit login_path

    fill_in(:name, with: @user1.name)
    fill_in(:password, with: @user1.password)
    click_button("Log In")

    visit new_user_movie_viewing_party_path(@user1, @movie1.id)
  end

  it 'has movie title' do
    expect(page).to have_content(@movie1.title)
  end

  describe 'form' do
    it 'has correct fields' do
      expect(@movie1.runtime).to eq("2 hours, 55 minutes") #thats 175 minutes :I
      expect(page).to have_field('Duration', with: 175)
      expect(page).to have_field('[date(1i)]')
      expect(page).to have_field('[date(2i)]')
      expect(page).to have_field('[date(3i)]')
      expect(page).to have_field('[time(4i)]')
      expect(page).to have_field('[time(5i)]')

      within "#user_#{@user2.id}" do
        expect(page).to have_unchecked_field
        expect(page).to have_content(@user2.name)
      end
      within "#user_#{@user3.id}" do
        expect(page).to have_unchecked_field
        expect(page).to have_content(@user3.name)
      end
      expect(page).to have_no_content(@user1.name)
    end

    it 'will not create viewing party less than movie runtime' do
      fill_in('Duration', with: 174)
      select "2024", from: '[date(1i)]'
      select "May", from: '[date(2i)]'
      select "5", from: '[date(3i)]'
      select "00", from: '[time(4i)]'
      select "00", from: '[time(5i)]'
      within "#user_#{@user3.id}" do
        check
      end
      click_on "Create Party"

      expect(page).to have_content("Error: Duration must be longer than movie runtime.")
      expect(current_path).to eq(new_user_movie_viewing_party_path(@user1, @movie1.id))
    end

    it 'redirects to dashboard' do
      fill_in('Duration', with: 176)
      select "2024", from: '[date(1i)]'
      select "May", from: '[date(2i)]'
      select "5", from: '[date(3i)]'
      select "00", from: '[time(4i)]'
      select "00", from: '[time(5i)]'
      within "#user_#{@user3.id}" do
        check
      end
      click_on "Create Party"

      expect(current_path).to eq(dashboard_path)
    end

    it 'redirects to dashboard' do
      fill_in('Duration', with: 176)
      select "2024", from: '[date(1i)]'
      select "May", from: '[date(2i)]'
      select "5", from: '[date(3i)]'
      select "00", from: '[time(4i)]'
      select "00", from: '[time(5i)]'
     
      click_on "Create Party"

      expect(current_path).to eq(new_user_movie_viewing_party_path(@user1, @movie1.id))
      expect(page).to have_content("Error: Must add users! Don't be a loner!")
    end

    it 'redirects to dashboard' do
      fill_in('Duration', with: 176)
      select "2022", from: '[date(1i)]'
      select "May", from: '[date(2i)]'
      select "00", from: '[time(4i)]'
      select "00", from: '[time(5i)]'
      within "#user_#{@user3.id}" do
        check
      end
     
      click_on "Create Party"

      expect(current_path).to eq(new_user_movie_viewing_party_path(@user1, @movie1.id))
      expect(page).to have_content("Error: Date can't be in the past")
    end
  end
end