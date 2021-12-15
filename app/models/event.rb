class Event < ApplicationRecord
  belongs_to :user
  validates :summary, :eid, presence: true
  before_destroy :delete_calendar_event

  def delete_calendar_event
    user.delete_event(eid)
  end
end
