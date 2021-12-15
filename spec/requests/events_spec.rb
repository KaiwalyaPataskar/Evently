require 'rails_helper'

RSpec.describe 'Events', type: :request do
  describe 'GET /index' do
    it 'should return a successful response' do
      create(:event)
      get events_path, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      event = create(:event)
      get event_url(event)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'without a valid user' do
      it 'should now create a new Event' do
        expect {
          post events_url, params: { event: { eid: 'Test1', summary: 'test summary' } }
        }.to change(Event, :count).by(0)
      end
    end
    context 'with valid parameters' do
      it 'creates a new Event' do
        user = create(:user)
        expect {
          post events_url, params: { event: { eid: 'Test1', summary: 'test summary', user_id: user.id } }
        }.to change(Event, :count).by(1)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested course' do
      event = create(:event)
      expect {
        delete event_url(event)
      }.to change(Event, :count).by(-1)
    end
  end
end
