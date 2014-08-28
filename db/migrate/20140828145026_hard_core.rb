class HardCore < ActiveRecord::Migration
  
  def up
    drop_table :lessons
    drop_table :lessons_resources
  end

  def down
  end

end
