class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.where(encrypted_email: params[:encrypted_email]).all
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        TicketMailer.delay.mail(@ticket)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ticket }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
      redirect_to( root_path, notice: "Ticket not found" ) and return if @ticket.blank?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:name, :email, :subject, messages_attributes: [:body])
    end
end
