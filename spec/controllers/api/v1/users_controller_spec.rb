require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  include_context 'API Context'

  describe 'POST /signup' do
    let(:valid_user_params) do
      {
        name: Faker::Name.name,
        password: Faker::Internet.password(20, 20),
        email: Faker::Internet.email,
        role: 'admin'
      }
    end

    let(:invalid_user_params) do
      {
        name: Faker::Name.name,
        password: Faker::Internet.password(20, 20)
      }
    end

    context 'creating a user' do
      it 'returns an authentication token' do
        post :create, params: valid_user_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    context 'creating a user using invalid params' do
      it 'returns unprocessable entity with failure message' do
        post :create, params: invalid_user_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message'])
          .not_to be_nil
      end
    end
  end

  describe 'GET /user' do
    context 'fetch current user data' do
      let(:user) { create(:user) }
      let(:token) { token_generator(user.id) }
      before(:each) { authorization_header(token) }
      it 'returns current user data' do
        get :show
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(user.id)
      end
    end

    context 'fetch current user data without sending token' do
      it 'returns unprocessable entity with failure message' do
        get :show
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message'])
          .not_to be_nil
      end
    end
  end

  describe 'GET /users' do
    let!(:user) { create(:user) }
    let!(:user_2) { create(:user) }
    let!(:user_3) { create(:user) }
    let!(:admin) { create(:admin_user) }
    let!(:admin_token) { token_generator(admin.id) }
    let!(:member_token) { token_generator(user.id) }
    context 'get list of users using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns current user data' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['total']).to eq(4)
      end
    end

    context 'get list of users using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns forbidden with failure message' do
        get :index
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['message'])
          .not_to be_nil
      end
    end
  end
end
