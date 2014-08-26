class LessonResource < ActiveRecord::Migration
    create_table :lessons_resources, id: false do |t|
      t.belongs_to :lesson, index: true
      t.belongs_to :resource, index: true
    end
end
