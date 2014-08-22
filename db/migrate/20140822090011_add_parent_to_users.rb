class AddParentToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :parent, index: true
  end
end
