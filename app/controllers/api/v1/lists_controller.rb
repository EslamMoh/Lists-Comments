module Api
  module V1
    class ListsController < Api::V1::BaseController
      before_action :set_list, only: %i[update destroy
                                        assign_member unassign_member]
      before_action :set_member, only: %i[assign_member unassign_member]

      # GET /api/v1/lists
      # fetches all lists if admin, fetch assigned lists for member
      def index
        lists = scope.includes(:admin).page(page).per(per)
        json_response(PageDecorator.decorate(lists).as_json(admin: true), :ok)
      end

      # GET /api/v1/lists/:id
      # fetch list by id
      def show
        @list = scope.includes(:cards).find(params[:id])
        json_response(@list.decorate.as_json(cards: true), :ok)
      end

      # POST /api/v1/lists
      # create new list
      def create
        @list = current_user.lists.new(list_params)

        if @list.save
          json_response(@list.decorate, :created)
        else
          json_response(@list.errors, :unprocessable_entity)
        end
      end

      # PUT /api/v1/lists/:id
      # update list by id
      def update
        if @list.update(list_params)
          json_response(@list.decorate, :created)
        else
          json_response(@list.errors, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/lists/:id
      # remove list
      def destroy
        @list.destroy
        head :no_content
      end

      # POST /api/v1/lists/:id/assign_member/:member_id
      # assign member to list
      def assign_member
        @member.assigned_lists << @list
        json_response({ message: 'List assigned successfully' }, :ok)
      end

      # DELETE /api/v1/lists/:id/unassign_member/:member_id
      # unassign member from list
      def unassign_member
        @member.assigned_lists.delete(@list)
        json_response({ message: 'List unassigned successfully' }, :ok)
      end

      private

      def set_list
        @list = current_user.lists.find(params[:id])
      end

      def scope
        return List if current_user.admin?

        current_user.assigned_lists
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
