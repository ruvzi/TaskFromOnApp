class Ticket < ActiveRecord::Base
  ACTIVE_STATES = %w(waiting_response waiting_customer)
  # Relationships
  belongs_to :owner, class_name: AdminUser
  has_many :messages, dependent: :destroy

  accepts_nested_attributes_for :messages, allow_destroy: true

  #Validators
  validates :name, :email, :subject, presence: true
  validates_associated :messages


  # Callbacks
  before_create :generate_encrypted_email, :strip_email, :generate_token, :generate_pusher_token

  # Scopes
  scope :find,       ->(param) { find_by(token: param) }

  scope :unassigned, -> { where(owner_id: nil) }
  scope :active,     -> { where(state: ACTIVE_STATES) }
  scope :hold,       -> { where(state: 'on_hold') }
  scope :canceled,   -> { where(state: 'canceled') }
  scope :completed,  -> { where(state: 'completed') }
  scope :me,         ->(u) {where(owner_id: u.id) }



  state_machine :state, initial: :waiting_response do
    state :waiting_response
    state :waiting_customer
    state :on_hold
    state :canceled
    state :completed

    event :respond do
      transition waiting_response: :waiting_customer, on_hold: :waiting_customer
    end

    event :wait do
      transition waiting_response: :waiting_response, waiting_customer: :waiting_response
    end

    event :hold do
      transition waiting_response: :on_hold, waiting_customer: :on_hold
    end

    event :cancel do
      transition waiting_response: :canceled, waiting_customer: :canceled, on_hold: :canceled
    end

    event :activate do
      transition canceled: :waiting_response
    end

    event :complete do
      transition waiting_response: :completed, waiting_customer: :completed, on_hold: :completed
    end
  end

  #ActiveAdmin Display Name
  def display_name
    self.name
  end

  def me?(u)
    self.owner.eql?(u)
  end

  def active?
    ACTIVE_STATES.include?(self.state)
  end

  def to_param
    token
  end

  private

  def strip_email
    self.email = self.email.strip
  end

  def generate_encrypted_email
    self.encrypted_email = Digest::SHA256.hexdigest(self.email)
  end

  def generate_token
    begin
      token = (0..4).map{|x| x.odd? ? (1..9).to_a.sample(3).join : (('A'..'Z').to_a-%w(I O)).sample(3).join }.join('-')
    end while Ticket.find_by(token: token).present?
    self.token = token
  end

  def generate_pusher_token
    begin
      token = SecureRandom.random_number(10**15)
    end while Ticket.find_by(pusher_token: token).present?
    self.pusher_token = token
  end
end
