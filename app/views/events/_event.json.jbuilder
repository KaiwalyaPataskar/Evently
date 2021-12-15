json.extract! event, :id, :summary, :description, :eid, :status, :organizer, :created_at, :updated_at
json.url event_url(event, format: :json)
