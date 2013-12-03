ActiveAdmin.register Message do
  config.filters = false

  belongs_to :ticket
  permit_params  :body, :author_id

  actions :index, :new, :create

  index do
    column :id
    column :author do |m|
      m.author.present? ? m.author.username : m.ticket.name
    end
    column :created_at do |m|
     l m.created_at, format: :short
    end
    column :body do |m|
      truncate m.body
    end
  end

  form do |f|
    f.inputs do
      f.input :body, input_html: { rows: 3 }
    end

    f.actions
  end

  controller do
    def create
      params[:message].merge!({ author_id: current_admin_user.id })
      create!
    end
  end
end
