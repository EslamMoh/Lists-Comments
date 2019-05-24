module Api
  module V1
    class CardsController < Api::V1::BaseController
      before_action :set_card, only: %i[update destroy]
      before_action :set_member, only: %i[assign_member unassign_member]

      # GET /api/v1/cards
      # fetches all cards for current user
      def index
        cards = scope.most_common.page(page).per(per)
        json_response(PageDecorator.decorate(cards), :ok)
      end

      # GET /api/v1/cards/:id
      # fetch card by id
      def show
        @card = scope.includes(:cards).find(params[:id])
        json_response(@card.decorate.as_json(cards: true), :ok)
      end

      # POST /api/v1/cards
      # create new card
      def create
        @card = current_user.cards.new(card_params)

        if @card.save
          json_response(@card.decorate, :created)
        else
          json_response(@card.errors, :unprocessable_entity)
        end
      end

      # PUT /api/v1/cards/:id
      # update card by id
      def update
        if @card.update(card_params)
          json_response(@card.decorate, :created)
        else
          json_response(@card.errors, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/cards/:id
      # remove card
      def destroy
        @card.destroy
        head :no_content
      end

      private

      def set_card
        @card = current_user.cards.find(params[:id])
      end

      def scope
        current_user.cards
      end

      def card_params
        params.fetch(:card, {}).permit(:title)
      end

      def set_member
        @member = User.find(params[:member_id])
      end
    end
  end
end
