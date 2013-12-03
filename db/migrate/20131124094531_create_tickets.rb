class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :email
      t.string :encrypted_email
      t.string :subject
      t.string :token
      t.string :state, index: true
      t.belongs_to :owner, index: true
      t.string :pusher_token

      t.timestamps
    end
  end
end
