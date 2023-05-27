# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :password_digest, presence: true
  validates :password, confirmation: { case_sensitive: true }
  has_secure_password
  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties

  enum role: %w(default admin)

  def hosted_viewing_parties
    self.user_viewing_parties.where(host: 'true')
  end

  def invited_viewing_parties
    self.user_viewing_parties.where(host: 'false')
  end
end
