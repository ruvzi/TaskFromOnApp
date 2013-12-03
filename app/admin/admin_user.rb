ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :username

  index do
    column :username
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :username
    end
    f.actions
  end

end
