class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.string :token, index: true
      t.references :guest, foreign_key: true, index: true

      t.timestamps
    end
  end
end
