require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    it 'should return a successful response' do
      create(:user)
      get events_path, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      user = create(:user)
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'without a valid params' do
      it 'should now create a new User' do
        expect {
          post users_url, params: { user: { name: 'Test1' } }
        }.to change(User, :count).by(0)
      end
    end
    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post users_url, params: { user: { name: 'Test1', email: 'test@email.com' } }
        }.to change(User, :count).by(1)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested course' do
      user = create(:user)
      expect {
        delete user_url(user)
      }.to change(User, :count).by(-1)
    end
  end
end
