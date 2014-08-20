class AddTagToResources < ActiveRecord::Migration
  def change
    add_column :resources, :tag, :string
  end
end
