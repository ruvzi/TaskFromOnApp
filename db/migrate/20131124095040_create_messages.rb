class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :ticket, index: true
      t.belongs_to :author, index: true
      t.text :body

      t.timestamps
    end
  end
end
