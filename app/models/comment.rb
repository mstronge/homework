class Comment < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user

  attr_accessible :lesson_id, :user_id, :body

  before_validation :set_type_owner

  validates :lesson, :user, :type_owner, :body, :presence => true
  
  private

    def set_type_owner
      self.type_owner = self.user.admin ? "teacher" : "student"
    end

end
