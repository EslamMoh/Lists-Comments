class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.references :admin, index: true, foreign_key: { to_table: :users }
      t.string :title
      t.timestamps
    end
  end
end
