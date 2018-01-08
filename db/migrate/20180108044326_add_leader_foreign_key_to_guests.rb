class AddLeaderForeignKeyToGuests < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :guests, :guests, column: :leader_id
  end
end
