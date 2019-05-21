class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string  :password_digest
      t.string  :email
      t.string  :name
      t.integer :role
      t.timestamps
    end
  end
end
