class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :type_owner, index: true
      t.text :body
      t.references :lesson, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
