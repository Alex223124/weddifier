class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :email, index: true
      t.string :password_digest
    end
  end
end
