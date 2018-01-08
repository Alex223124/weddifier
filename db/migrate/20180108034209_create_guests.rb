class CreateGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :guests do |t|
      t.string :first_name, index: true
      t.string :last_name
      t.string :father_surname
      t.string :mother_surname
      t.string :phone
      t.string :email, index: true
      t.references :admin, foreign_key: true, index: true
      t.references :leader, index: true
      t.timestamps
    end
  end
end
