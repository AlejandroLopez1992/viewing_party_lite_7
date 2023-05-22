# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe 'validations' do
    it { should validate_presence_of :duration }
    it { should validate_numericality_of :duration }
    it { should validate_presence_of :time }
    it { should validate_presence_of :date }
    it { should validate_presence_of :movie_id }
    it { should validate_numericality_of :movie_id }
    it { should have_many :user_viewing_parties}
    it { should have_many(:users).through(:user_viewing_parties)}
  end

  it 'can find host' do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user2 = User.create!(name: 'Mary', email: 'Mary@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @viewing_party1 = ViewingParty.create!(duration: 120, date: '12/12/2023', time: '2023-12-12 13:00:00 UTC', movie_id: 275)
    @user_viewing_party1 = UserViewingParty.create!(user_id: @user2.id, viewing_party_id: @viewing_party1.id, host: true)
    @user_viewing_party2 = UserViewingParty.create!(user_id: @user1.id, viewing_party_id: @viewing_party1.id)

    expect(@viewing_party1.host).to eq(@user2.name)
  end
end
