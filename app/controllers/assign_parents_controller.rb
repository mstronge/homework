class AssignParentsController < ApplicationController
  
  def index
    @students = User.only_students_without_parent.paginate(:page => params[:page], :per_page => 10)
    @parents = User.only_parents
    @assign_parents  = @students
    @title = "Assign Parents"
  end

end
