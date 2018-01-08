class Guest < ActiveRecord::Base
  has_one :plus_one, class_name: 'Guest', foreign_key: 'leader_id'
  belongs_to :leader, class_name: 'Guest', optional: true
  # Optional is true because a Guest does not always needs a leader, it can
  # either be a leader himself, or be a plus one and indeed need a leader.

  has_one :invitation
end
