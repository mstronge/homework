class AssignParentsController < ApplicationController
  
  def index
    @students = User.only_students_without_parent
    @parents = User.only_parents
    @title = "Assign Parents"
  end

end
