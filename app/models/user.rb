class User < ApplicationRecord
  include GoogleCalendarApi

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  has_many :events

  def is_authorized
    auth_config['access_token'].present?
  end

  def is_auth_expired
    auth_config['expired'] == true
  end

  def google_auth_url
    url = AUTH_URL.dup
    params = {
      scope: 'https://www.googleapis.com/auth/calendar',
      response_type: 'code',
      redirect_uri: CALLBACK_URL,
      client_id: Rails.application.credentials.config[:google][:client_id],
      state: { id: id }.to_json
    }.to_query
    url.concat params
  end
end
