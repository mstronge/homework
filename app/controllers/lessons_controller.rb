class LessonsController < ApplicationController
  
  before_filter :admin_user, :only => [ :index, :new, :create, :update ]
  
  def index
    @title = "All lessons"
  end

  def new
    @title = "All lessons"
    @lesson = Lesson.new
    @students = User.only_students
    @resources = Resource.order(updated_at: :desc)
  end

  def create
    binding.pry
  end

  private

    def admin_user
      redirect_to(root_path) if !current_user.admin?
    end

end