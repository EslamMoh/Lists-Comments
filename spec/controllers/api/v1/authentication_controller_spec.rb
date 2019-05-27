require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  include_context 'API Context'
  # Authentication test suite
  describe 'POST /auth/login' do
    # create test user
    let!(:user) { create(:user) }
    # set test valid and invalid credentials
    let(:valid_credentials) do
      {
        email: user.email,
        password: user.password,
        role: 'member'
      }
    end
    let(:invalid_credentials) do
      {
        email: Faker::Internet.email,
        password: Faker::Internet.password,
        role: 'member'
      }
    end

    # returns auth token when request is valid
    context 'When request is valid' do
      it 'returns an authentication token' do
        post :authenticate, params: valid_credentials
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    context 'When request is invalid' do
      it 'returns a failure message' do
        post :authenticate, params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message'])
          .to match('Invalid credentials')
      end
    end
  end
end
