class CreateMemberLists < ActiveRecord::Migration[5.1]
  def change
    create_table :member_lists do |t|
      t.references :user, index: true, foreign_key: { to_table: :users }
      t.references :list, index: true, foreign_key: { to_table: :lists }
      t.timestamps
    end
  end
end
