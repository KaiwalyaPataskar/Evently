module GoogleCalendarApi
  include ActiveSupport::Concern

  def load_events
    url = "https://www.googleapis.com/calendar/v3/calendars/#{email}/events"
    connection = Faraday.new(url: url)
    response = connection.send('get') do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{auth_config['access_token']}"
      request.params['timeMin'] = '2021-12-15T05:30:00Z'
    end

    if response&.body
      return JSON.parse(response.body)
    else
      return { error: 'Something went wrong!' }
    end
  end
end
