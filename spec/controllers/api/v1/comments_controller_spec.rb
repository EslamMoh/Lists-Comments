require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
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
  let!(:first_comment) { create(:comment, commentable: first_card, user: admin) }
  let!(:second_comment) { create(:comment, commentable: first_comment, user: member) }
  let!(:third_comment) { create(:comment) }

  describe 'GET /comments' do
    context 'fetching all comments on card or other comment using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns all comments' do
        get :index, params: { commentable_type: 'Card', commentable_id: first_card.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['records'].size).to eq(1)
      end
    end

    context 'fetching all comments on card or other comment in members assigned list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns all comments' do
        get :index, params: { commentable_type: 'Card', commentable_id: first_card.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['total']).to eq(1)
      end
    end

    context 'fetching all comments in members unassigned list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns ok without records' do
        get :index, params: { commentable_type: 'Card', commentable_id: third_comment.commentable.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['total']).to eq(0)
      end
    end
  end

  describe 'GET /comments/:id' do
    context 'fetching any comment by comment id using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns comment' do
        get :show, params: { id: third_comment.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(third_comment.id)
      end
    end

    context 'fetching comment from member assigned lists by its id using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns comment' do
        get :show, params: { id: first_comment.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(first_comment.id)
      end
    end

    context 'fetching comment by its id which is not from assigned list to member using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        get :show, params: { id: third_comment.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /comments/:list_id' do
    let(:available_member_comment_params) do
      {
        content: 'This is a testing content',
        commentable_type: 'Card',
        commentable_id: first_card.id
      }
    end

    let(:unavailable_member_comment_params) do
      {
        content: 'This is a testing content',
        commentable_type: 'Card',
        commentable_id: third_card.id
      }
    end

    context 'create comment to any card using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns created comment' do
        post :create, params: { comment: unavailable_member_comment_params }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).to eq(Comment.last.id)
      end
    end

    context 'create comment to a card in assigned list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns created comment' do
        post :create, params: { comment: available_member_comment_params }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).to eq(Comment.last.id)
      end
    end

    context 'create comment to a card in unassigned list using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        post :create, params: { comment: unavailable_member_comment_params }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT /comments/:id' do
    let(:comment_params) do
      {
        content: 'This is a testing content'
      }
    end

    context 'updating admin comment by comment id using admin token' do
      let(:forth_comment) { create(:comment, commentable: first_card, user: member) }
      before(:each) { authorization_header(admin_token) }
      it 'returns comment' do
        put :update, params: { id: forth_comment.id,
                               comment: comment_params }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(forth_comment.id)
      end
    end

    context 'updating comment that not belong to admin by comment id using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        put :update, params: { id: third_comment.id,
                               comment: comment_params }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'updating member comment by comment id using member token' do
      let(:forth_comment) { create(:comment, commentable: first_card, user: member) }
      before(:each) { authorization_header(member_token) }
      it 'returns comment' do
        put :update, params: { id: forth_comment.id,
                               comment: comment_params }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'updating comment that not belong to member by comment id using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        put :update, params: { id: third_comment.id,
                               comment: comment_params }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /comments/:id' do
    context 'deleting admin comment by comment id using admin token' do
      let(:forth_comment) { create(:comment, commentable: first_card, user: member) }
      before(:each) { authorization_header(admin_token) }
      it 'returns no content' do
        delete :destroy, params: { id: forth_comment.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'deleting comment that not belong to admin by comment id using admin token' do
      before(:each) { authorization_header(admin_token) }
      it 'returns not found' do
        delete :destroy, params: { id: third_comment.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'deleting member comment by comment id using member token' do
      let(:forth_comment) { create(:comment, commentable: first_card, user: member) }
      before(:each) { authorization_header(member_token) }
      it 'returns no content' do
        delete :destroy, params: { id: forth_comment.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'deleting comment that not belong to member by comment id using member token' do
      before(:each) { authorization_header(member_token) }
      it 'returns not found' do
        delete :destroy, params: { id: third_comment.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
