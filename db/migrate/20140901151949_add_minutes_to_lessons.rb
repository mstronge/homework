class AddMinutesToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :minutes_hash, :string
  end
end
