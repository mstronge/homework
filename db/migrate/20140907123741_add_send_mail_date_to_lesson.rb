class AddSendMailDateToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :last_send_mail_datetime, :datetime
  end
end
