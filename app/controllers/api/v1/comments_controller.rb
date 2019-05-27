module Api
  module V1
    class CommentsController < Api::V1::BaseController
      before_action :set_comment, only: %i[update destroy]
      # GET /api/v1/comments
      # fetches all comments for resource (Card or Comment)
      # commentable type and commentable id params should be sent as query strings
      def index
        comments = commentable_scope.page(page).per(per)
        authorize comments
        json_response(PageDecorator.decorate(comments), :ok)
      end

      # GET /api/v1/comments/:id
      # fetch comment by id and list id
      def show
        comment = CommentPolicy::Scope.new(current_user, Comment)
                                      .comments_and_replies_scope
                                      .find(params[:id])
        authorize comment
        json_response(comment.decorate.as_json(replies: true), :ok)
      end

      # POST /api/v1/comments
      # create new comment
      def create
        comment = creation_commentable_scope.new(comment_params)
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
        @comment = scope.find(params[:id])
      end

      def scope
        CommentPolicy::Scope.new(current_user, Comment)
                            .update_and_remove_scope
      end

      def comment_params
        params.fetch(:comment, {}).permit(:content, :commentable_type,
                                          :commentable_id)
              .merge(user_id: current_user.id)
      end

      def commentable_scope
        if params[:commentable_type].upcase == 'CARD'
          return policy_scope(Comment).where(commentable_id: params[:commentable_id],
                                             commentable_type: 'Card')
        end
        policy_scope(Comment).find(params[:commentable_id]).replies
      end

      def creation_commentable_scope
        if comment_params[:commentable_type].upcase == 'CARD'
          return CardPolicy::Scope.new(current_user, Card).users_scope
                                  .find(comment_params[:commentable_id])
                                  .comments
        end
        policy_scope(Comment).find(comment_params[:commentable_id]).replies
      end
    end
  end
end
