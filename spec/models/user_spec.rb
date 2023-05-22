# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_presence_of(:password_digest)}
    it { should validate_presence_of(:password)}
    it { should have_secure_password }
    it { should have_many :user_viewing_parties}
    it { should have_many(:viewing_parties).through(:user_viewing_parties)}
  end

  it 'can list hosted viewing parties' do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @viewing_party1 = ViewingParty.create!(duration: 120, date: '12/12/2023', time: '2023-12-12 13:00:00 UTC', movie_id: 275)
    @user_viewing_party = UserViewingParty.create!(user_id: @user1.id, viewing_party_id: @viewing_party1.id, host: true)

    expect(@user1.hosted_viewing_parties).to eq([@user_viewing_party])
    expect(@user1.invited_viewing_parties).to eq([])
  end

  it 'can list invited viewing parties' do
    @user1 = User.create!(name: 'JoJo', email: 'JoJo@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @user2 = User.create!(name: 'Mary', email: 'Mary@hotmail.com', password: 'password123', password_confirmation: 'password123')
    @viewing_party1 = ViewingParty.create!(duration: 120, date: '12/12/2023', time: '2023-12-12 13:00:00 UTC', movie_id: 275)
    @user_viewing_party1 = UserViewingParty.create!(user_id: @user2.id, viewing_party_id: @viewing_party1.id, host: true)
    @user_viewing_party2 = UserViewingParty.create!(user_id: @user1.id, viewing_party_id: @viewing_party1.id)

    expect(@user1.hosted_viewing_parties).to eq([])
    expect(@user1.invited_viewing_parties).to eq([@user_viewing_party2])
  end
end
