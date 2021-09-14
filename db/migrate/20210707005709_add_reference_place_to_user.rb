class AddReferencePlaceToUser < ActiveRecord::Migration[6.1]
  def up
    add_reference :places, :user
  end

  def dowm
    remove_reference :places, :user
  end
end
