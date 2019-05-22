class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string :title
      t.string :description
      t.integer :comments_count, default: 0
      t.references :user, index: true, foreign_key: { to_table: :users }
      t.references :list, index: true, foreign_key: { to_table: :lists }
      t.timestamps
    end
  end
end
