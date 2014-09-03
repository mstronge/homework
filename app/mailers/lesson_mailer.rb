class LessonMailer < ActionMailer::Base
  
  default from: 'homework@noreplay.com'

  def send_activity_by_lesson(activity, lesson)
      @lesson = lesson
      @activity = activity
      subject = @activity=="create" ? "For you was created new lesson" : "Your lesson was updated"
      mail(to: @lesson.user.email, subject: subject).deliver
  end

end
