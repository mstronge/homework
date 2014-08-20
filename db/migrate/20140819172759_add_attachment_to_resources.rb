class AddAttachmentToResources < ActiveRecord::Migration
  def change
    add_column :resources, :attachment, :string
  end
end
