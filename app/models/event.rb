class Event < ApplicationRecord
  belongs_to :user
  validates :summary, :eid, presence: true
end
