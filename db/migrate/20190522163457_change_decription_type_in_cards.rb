class ChangeDecriptionTypeInCards < ActiveRecord::Migration[5.1]
  def up
    change_column :cards, :description, :text
  end

  def down
    change_column :cards, :description, :string
  end
end
