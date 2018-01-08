class Invitation < ActiveRecord::Base
  belongs_to :guest
end
