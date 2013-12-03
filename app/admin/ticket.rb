ActiveAdmin.register Ticket do
  permit_params  :state, :owner_id
  actions :index, :edit, :update

  filter :token
  filter :subject
  filter :messages_body, as: :string

  scope :all, default: true
  scope :unassigned
  scope :active
  scope :hold
  scope :canceled
  scope :completed
  scope (:me) {|tickets| tickets.me(current_admin_user) }

  index do
    column :id
    column :subject
    column :name
    column :email
    column :owner
    column :state
    actions do |t|
      links = []
      links.push link_to('To Hold', hold_admin_ticket_path(t)) if t.active?
      if t.canceled?
        links.push link_to('Activate', activate_admin_ticket_path(t))
      else
        links.push link_to('Cancel', cancel_admin_ticket_path(t))
        links.push link_to('Complete', complete_admin_ticket_path(t))
      end
      if t.me?(current_admin_user)
        links.push link_to('Messages', admin_ticket_messages_path(t))
        links.push link_to('Add Responce', new_admin_ticket_message_path(t))
      end
      links.join(' ').html_safe
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :owner
    end
    f.actions
  end

  member_action :hold, method: :get do
    ticket = Ticket.find params[:id]
    ticket.hold!
    redirect_to collection_path
  end

  member_action :cancel, method: :get do
    ticket = Ticket.find params[:id]
    ticket.cancel!
    redirect_to collection_path
  end

  member_action :activate, method: :get do
    ticket = Ticket.find params[:id]
    ticket.activate!
    redirect_to collection_path
  end

  member_action :complete, method: :get do
    ticket = Ticket.find params[:id]
    ticket.complete!
    redirect_to collection_path
  end

end
