class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tickets, foreign_key: :owner_id
  has_many :messages, foreign_key: :author_id

  before_create :generate_pusher_token

  #ActiveAdmin Display Name
  def display_name
    self.username
  end

  private
  def generate_pusher_token
    begin
      token = SecureRandom.random_number(10**15)
    end while AdminUser.find_by(pusher_token: token).present?
    self.pusher_token = token
  end
end
