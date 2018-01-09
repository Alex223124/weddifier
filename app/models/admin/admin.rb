module Admin
  class Admin < ActiveRecord::Base
    has_secure_password

    validates_presence_of :email
    validates_presence_of :password

    validates_length_of :password, { minimum: 4 }
  end
end
