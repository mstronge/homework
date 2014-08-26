class Lessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.text :must_be_practised
      t.text :how_to_practise
      t.references :user, index: true
      t.date :date_start
      t.date :date_finish
      t.string :status
      t.string :raiting
      t.timestamps
    end
  end
end
