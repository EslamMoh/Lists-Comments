module Api
  module V1
    class CommentsController < Api::V1::BaseController
      before_action :set_comment, only: %i[update destroy]

      # GET /api/v1/comments/:list_id
      # fetches all comments for current user for list
      def index
        comments = scope.most_common.page(page).per(per)
        authorize comments
        json_response(PageDecorator.decorate(comments), :ok)
      end

      # GET /api/v1/comments/:list_id/:id
      # fetch comment by id and list id
      def show
        comment = scope.includes(:comments).find(params[:id])
        authorize comment
        json_response(comment.decorate.as_json(comments: true), :ok)
      end

      # POST /api/v1/comments/:list_id
      # create new comment
      def create
        comment = scope.new(comment_params)
        authorize comment

        if comment.save
          json_response(comment.decorate, :created)
        else
          json_response(comment.errors, :unprocessable_entity)
        end
      end

      # PUT /api/v1/comments/:id
      # update comment by id
      def update
        authorize @comment

        if @comment.update(comment_params)
          json_response(@comment.decorate, :ok)
        else
          json_response(@comment.errors, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/comments/:id
      # remove comment
      def destroy
        authorize @comment
        @comment.destroy
        head :no_content
      end

      private

      def set_comment
        @comment = policy_scope(Comment).find(params[:id])
      end

      def scope
        policy_scope(List).find(Card.find(params[:card_id]).includes(:list)
                                .list.id).includes(:comments).comments
      end

      def comment_params
        params.fetch(:comment, {}).permit(:title, :description)
              .merge(user: current_user)
      end
    end
  end
end
