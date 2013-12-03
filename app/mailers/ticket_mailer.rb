class TicketMailer < ActionMailer::Base
  default from: "from@example.com"

  def message_mail(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "#{@ticket.messages.last.responce? ? 'RE: ' : ''}Your Support Ticket: #{@ticket.subject}") do |format|
      format.html { render layout: 'mailer' }
      format.text
    end
  end
end
