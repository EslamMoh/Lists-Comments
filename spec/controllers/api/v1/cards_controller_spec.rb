require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :controller do
  include_context 'API Context'
  let!(:member) { create(:user) }
  let!(:member_token) { token_generator(member.id) }
  let!(:admin) { create(:admin_user)}
  let!(:admin_token) { token_generator(admin.id) }
  let!(:first_list) { create(:list, admin: admin) }
  let!(:second_list) { create(:list) }
  let!(:third_list) { create(:list) }
  let!(:first_member_list) { create(:member_list, user: member, list: first_list) }
  let!(:second_member_list) { create(:member_list, user: member, list: second_list) }
  let!(:first_card) { create(:card, user: member, list: first_list) }
  let!(:second_card) { create(:card, list: second_list) }
  let!(:third_card) { create(:card) }

  describe 'GET /cards/list/:list_id' do
    context 'fetching all cards using admin token and list id' do
      before(:each) { authorization_header(admin_token) }
      it 'returns all cards' do
        get :index, params: { list_id: third_card.list_id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['records'].size).to eq(1)
      end
    end

    context 'fetching all cards in members not assigned list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns ok with empty records' do
        get :index, params: { list_id: third_list.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['total']).to eq(0)
      end
    end

    context 'fetching all cards in members list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns ok' do
        get :index, params: { list_id: first_list.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['records'].size).to eq(1)
      end
    end

    context 'fetching cards without token' do
      it 'returns unprocessable entity with failure message' do
        get :index, params: { list_id: first_list.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message'])
          .not_to be_nil
      end
    end
  end

  describe 'GET /cards/:id' do
    context 'fetching any card by card id using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns card' do
        get :show, params: { id: third_card.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(third_card.id)
      end
    end

    context 'fetching card from member assigned lists by its id using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns card' do
        get :show, params: { id: first_card.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(first_card.id)
      end
    end

    context 'fetching card by its id which is not from assigned list to member using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        get :show, params: { id: third_card.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /cards/:list_id' do
    let(:card_params) do
      {
        description: "This is a testing description",
        title: Faker::Company.name
      }
    end

    context 'create card to any list using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns created card' do
        post :create, params: { card: card_params, list_id: third_list.id }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).to eq(Card.last.id)
      end
    end

    context 'create card to assigned list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns created card' do
        post :create, params: { card: card_params, list_id: second_list.id }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).to eq(Card.last.id)
      end
    end

    context 'create card to unassigned list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns unprocessable entity' do
        post :create, params: { card: card_params, list_id: third_list.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT /cards/:id' do
    let(:card_params) do
      {
        description: "This is a testing description",
        title: Faker::Company.name
      }
    end

    context 'updating admin card by card id using admin token' do
      let(:forth_card) { create(:card, user: admin, list: first_list) }
      before(:each) { authorization_header(admin_token) }
      it 'returns card' do
        put :update, params: { id: forth_card.id,
                               card: card_params }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(forth_card.id)
      end
    end

    context 'updating card that not belong to admin by card id using admin token' do
      let(:forth_card) { create(:card, user: member, list: first_list) }
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        put :update, params: { id: forth_card.id,
                               card: card_params }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'updating member card by card id using member token' do
      let(:forth_card) { create(:card, user: member, list: first_list) }
      before(:each) { authorization_header(member_token) }
      it 'returns card' do
        put :update, params: { id: forth_card.id,
                               card: card_params }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'updating card that not belong to member by card id using member token' do
      let(:forth_card) { create(:card, list: first_list) }
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        put :update, params: { id: forth_card.id,
                               card: card_params }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /cards/:id' do
    context 'deleting admin card by card id using admin token' do
      let(:forth_card) { create(:card, user: admin, list: first_list) }
      before(:each) { authorization_header(admin_token) }
      it 'returns no content' do
        put :destroy, params: { id: forth_card.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'deleting card that not belong to admin by card id using admin token' do
      let(:forth_card) { create(:card, user: member, list: first_list) }
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        put :destroy, params: { id: forth_card.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'deleting member card by card id using member token' do
      let(:forth_card) { create(:card, user: member, list: first_list) }
      before(:each) { authorization_header(member_token) }
      it 'returns no content' do
        put :destroy, params: { id: forth_card.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'deleting card that not belong to member by card id using member token' do
      let(:forth_card) { create(:card, list: first_list) }
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        put :destroy, params: { id: forth_card.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
