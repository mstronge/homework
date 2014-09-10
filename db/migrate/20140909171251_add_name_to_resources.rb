class AddNameToResources < ActiveRecord::Migration
  def change
    add_column :resources, :name, :string
    add_index :resources, :name, unique: true
  end
end
