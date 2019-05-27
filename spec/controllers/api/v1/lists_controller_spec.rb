require 'rails_helper'

RSpec.describe Api::V1::ListsController, type: :controller do
  include_context 'API Context'
  let!(:member) { create(:user) }
  let!(:member_token) { token_generator(member.id) }
  let!(:admin) { create(:admin_user)}
  let!(:admin_token) { token_generator(admin.id) }
  let!(:first_list) { create(:list, admin: admin) }
  let!(:second_list) { create(:list) }
  let!(:member_list) { create(:member_list, user: member, list: second_list) }

  describe 'GET /lists' do
    context 'fetching all lists using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns all lists' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['records'].size).to eq(2)
      end
    end

    context 'fetching all assigned lists using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns assigned lists only' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['records'].size).to eq(1)
      end
    end

    context 'fetching lists without token' do
      it 'returns unprocessable entity with failure message' do
        get :index
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message'])
          .not_to be_nil
      end
    end
  end

  describe 'GET /lists/:id' do
    context 'fetching any list by list id using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns list' do
        get :show, params: { id: second_list.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(second_list.id)
      end
    end

    context 'fetching assigned list by its id using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns list' do
        get :show, params: { id: second_list.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(second_list.id)
      end
    end

    context 'fetching list by its id which is not assigned to member using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        get :show, params: { id: first_list.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /lists' do
    let(:list_params) do
      {
        admin_id: admin.id,
        title: Faker::Company.name
      }
    end
    let(:invalid_list_params) do
      {
        admin_id: admin.id
      }
    end
    context 'create list using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns created list' do
        post :create, params: list_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).to eq(List.last.id)
      end
    end

    context 'create list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns forbidden' do
        post :create
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'create list using invalid params' do
      before(:each) { authorization_header(admin_token) }
      it 'returns unprocessable entity' do
        post :create, params: invalid_list_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body))
          .not_to be_nil
      end
    end
  end

  describe 'PUT /lists/:id' do
    let(:list_params) do
      {
        admin_id: admin.id,
        title: Faker::Company.name
      }
    end
    context 'updating list by list id using admin' do
      before(:each) { authorization_header(admin_token) }
      it 'returns list' do
        put :update, params: { id: first_list.id,
                               list: list_params }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(first_list.id)
      end
    end

    context 'updating list by its id using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns forbidden' do
        put :update, params: { id: second_list.id,
                               list: list_params }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'updating list by invalid list id' do
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        put :update, params: { id: Faker::Number.number(2),
                               list: list_params }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /lists/:id' do
    context 'deleting list by list id using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns list' do
        delete :destroy, params: { id: first_list.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'deleting list by its id using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns forbidden' do
        delete :destroy, params: { id: second_list.id }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'deleting list by invalid list id' do
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        delete :destroy, params: { id: Faker::Number.number(2) }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /lists/:id/assign_member/:member_id' do
    context 'assign member to list by ids' do
      before(:each) { authorization_header(admin_token) }
      it 'returns ok' do
        post :assign_member,
             params: { id: first_list, member_id: member.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("List assigned successfully")
      end
    end

    context 'assign member to already assigned list by ids' do
      let!(:member_list_2) { create(:member_list, user: member, list: first_list) }
      before(:each) { authorization_header(admin_token) }
      it 'returns unprocessable entity' do
        post :assign_member,
             params: { id: first_list, member_id: member.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'assign member to not owner list by ids' do
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        post :assign_member,
             params: { id: Faker::Number.number(2),
                       member_id: member.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'assign admin to list by ids' do
      before(:each) { authorization_header(admin_token) }
      it 'returns unprocessable entity' do
        post :assign_member,
             params: { id: first_list,
                       member_id: admin.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /lists/:id/unassign_member/:member_id' do
    context 'unassign member from list by ids' do
      let!(:member_list_2) { create(:member_list, user: member, list: first_list) }
      before(:each) { authorization_header(admin_token) }
      it 'returns ok' do
        post :unassign_member,
             params: { id: first_list, member_id: member.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("List unassigned successfully")
      end
    end

    context 'unassign member to not owner list by ids' do
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        post :unassign_member,
             params: { id: Faker::Number.number(2),
                       member_id: member.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
