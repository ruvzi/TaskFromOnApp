class Message < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :author, class_name: AdminUser

  #Validators
  validates :body, presence: true

  after_create :update_ticket_state, :send_mail

  scope :ordered, -> { order('created_at desc') }

  def responce?
    author_id.present?
  end

  private
  def update_ticket_state
    self.author.present? ? self.ticket.respond! : self.ticket.wait!
  end

  def send_mail
    TicketMailer.delay.message_mail(self.ticket)
  end
end
