module Api
  module V1
    class CardsController < Api::V1::BaseController
      before_action :set_card, only: %i[update destroy]

      # GET /api/v1/cards/:list_id
      # fetches all cards for current user for list
      def index
        cards = scope.most_common.page(page).per(per)
        authorize cards
        json_response(PageDecorator.decorate(cards), :ok)
      end

      # GET /api/v1/cards/:list_id/:id
      # fetch card by id and list id
      def show
        card = scope.includes(:comments).find(params[:id])
        authorize card
        json_response(card.decorate.as_json(comments: true), :ok)
      end

      # POST /api/v1/cards/:list_id
      # create new card
      def create
        card = scope.new(card_params)
        authorize card

        if card.save
          json_response(card.decorate, :created)
        else
          json_response(card.errors, :unprocessable_entity)
        end
      end

      # PUT /api/v1/cards/:id
      # update card by id
      def update
        authorize @card

        if @card.update(card_params)
          json_response(@card.decorate, :ok)
        else
          json_response(@card.errors, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/cards/:id
      # remove card
      def destroy
        authorize @card
        @card.destroy
        head :no_content
      end

      private

      def set_card
        @card = policy_scope(Card).find(params[:id])
      end

      def scope
        policy_scope(List).find(params[:list_id]).includes(:cards).cards
      end

      def card_params
        params.fetch(:card, {}).permit(:title, :description)
              .merge(user: current_user)
      end
    end
  end
end
