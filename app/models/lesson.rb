class Lesson < ActiveRecord::Base
  
  has_and_belongs_to_many :resources
  belongs_to :user
  
  attr_accessible :name, :user_id, :date_start, :date_finish, :must_be_practised, :how_to_practise, :status, :raiting, :resource_ids

  before_validation :new_record_status

  validates :name, :presence => true, :length => { :maximum => 50 }
  validates  :user, :date_start, :date_finish, :must_be_practised, :how_to_practise, :status, :raiting, :presence => true

  validate :validate_date
   
  scope :equal_param, ->(hash){ where(hash.reject{|k,v| v.blank? || k =~ /^(date)/ }) }
  scope :search_date_finish_not_less, ->(date){ where('"date_finish" >= ?', date.to_date) if date.present? }
  scope :search_date_start_not_more, ->(date){ where('"date_start" <= ?', date.to_date) if date.present? }
  scope :search, ->(params) {equal_param(params).search_date_finish_not_less(params[:date_start]).search_date_start_not_more(params[:date_finish]) }
  
private

  def validate_date
    if date_start.present? && date_finish.present?
     errors.add(:date_finish," can't be less than date_start") if date_finish < date_start
     errors.add(:student_or_date," the student has a lesson for this period") if Lesson.equal_param(user_id: self.user_id).search_date_finish_not_less(self.date_start).search_date_start_not_more(self.date_start).size > 0
    end
  end

  def new_record_status
    self.status = "new" if new_record?
  end

end