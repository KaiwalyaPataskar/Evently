module GoogleCalendarApi
  include ActiveSupport::Concern

  def load_events
    url = "https://www.googleapis.com/calendar/v3/calendars/#{email}/events"
    connection = Faraday.new(url: url)
    response = connection.send('get') do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{auth_config['access_token']}"
      request.params['timeMin'] = Date.today.strftime('%FT%TZ')
    end

    if response&.body
      return JSON.parse(response.body)
    else
      return { error: 'Something went wrong!' }
    end
  end

  def delete_event(event_id)
    url = "https://www.googleapis.com/calendar/v3/calendars/#{email}/events/#{event_id}"
    connection = Faraday.new(url: url)
    connection.send('delete') do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{auth_config['access_token']}"
    end
  end
end
