class AddUserParameters < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :name, :string, null: false
    add_column :users, :sex, :string
    add_column :users, :date_of_birth, :datetime
  end
end
