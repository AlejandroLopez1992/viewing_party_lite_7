require 'rails_helper'

RSpec.describe UserViewingParty, type: :model do
  describe 'validations' do
    it { should belong_to :user }
    it { should belong_to :viewing_party}
  end

  it 'can get movie title', :vcr do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @viewing_party1 = ViewingParty.create!(duration: 120, date: '12/12/2023', time: '2023-12-12 13:00:00 UTC', movie_id: 275)
    @user_viewing_party = UserViewingParty.create!(user_id: @user1.id, viewing_party_id: @viewing_party1.id)

    expect(@user_viewing_party.movie_title).to eq("Fargo")
  end

  it 'can get movie_image', :vcr do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @viewing_party1 = ViewingParty.create!(duration: 120, date: '12/12/2023', time: '2023-12-12 13:00:00 UTC', movie_id: 275)
    @user_viewing_party = UserViewingParty.create!(user_id: @user1.id, viewing_party_id: @viewing_party1.id)

    expect(@user_viewing_party.movie_image).to eq("/rt7cpEr1uP6RTZykBFhBTcRaKvG.jpg")
  end
end