class UpdateAdminUserRole < ActiveRecord::Migration
  def up
    execute("UPDATE users SET role='teacher' WHERE admin='t';")
  end
  def down
  end
end
