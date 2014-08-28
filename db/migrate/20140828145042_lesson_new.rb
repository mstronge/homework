class LessonNew < ActiveRecord::Migration
  
  def change
   
    drop_table :lessons

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

    create_table :lessons_resources, id: false do |t|
      t.belongs_to :lesson, index: true
      t.belongs_to :resource, index: true
    end

  end
  
end
