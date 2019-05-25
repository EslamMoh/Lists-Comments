module Api
  module V1
    class ListsController < Api::V1::BaseController
      before_action :set_list, only: %i[update destroy
                                        assign_member unassign_member]
      before_action :set_member, only: %i[assign_member unassign_member]

      # GET /api/v1/lists
      # fetches all lists if admin, fetch assigned lists for member
      def index
        lists = policy_scope(List).includes(:admin).page(page).per(per)
        authorize lists
        json_response(PageDecorator.decorate(lists).as_json(admin: true), :ok)
      end

      # GET /api/v1/lists/:id
      # fetch list by id
      def show
        list = policy_scope(List).includes(:cards).find(params[:id])
        authorize list
        json_response(list.decorate.as_json(cards: true), :ok)
      end

      # POST /api/v1/lists
      # create new list
      def create
        list = scope.new(list_params)
        authorize list

        if @list.save
          json_response(list.decorate, :created)
        else
          json_response(list.errors, :unprocessable_entity)
        end
      end

      # PUT /api/v1/lists/:id
      # update list by id
      def update
        authorize @list

        if @list.update(list_params)
          json_response(@list.decorate, :ok)
        else
          json_response(@list.errors, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/lists/:id
      # remove list
      def destroy
        authorize @list
        @list.destroy
        head :no_content
      end

      # POST /api/v1/lists/:id/assign_member/:member_id
      # assign member to list
      def assign_member
        authorize List
        @member.assigned_lists << @list
        json_response({ message: 'List assigned successfully' }, :ok)
      end

      # DELETE /api/v1/lists/:id/unassign_member/:member_id
      # unassign member from list
      def unassign_member
        authorize List
        @member.assigned_lists.delete(@list)
        json_response({ message: 'List unassigned successfully' }, :ok)
      end

      private

      def set_list
        @list = scope.find(params[:id])
      end

      def scope
        ListPolicy::Scope.new(current_user, List).scope
      end

      def list_params
        params.fetch(:list, {}).permit(:title)
      end

      def set_member
        @member = User.find(params[:member_id])
      end
    end
  end
end
