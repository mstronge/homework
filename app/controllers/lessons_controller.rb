class LessonsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :admin_user, :only => [ :index, :new, :create, :destroy ]
  before_filter :correct_user_or_parent_or_admin, :only => [:update, :show]
  
  def index
    @title = "All lessons"
    @students = User.only_students
    @lessons = Lesson.search(search_params).eager_load(:user).order(sort_column + " " + sort_direction) .paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @title = "New lesson"
    @lesson = Lesson.new
    @students = User.only_students
    @resources = Resource.all
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      flash[:success] = "Lesson with id=#{@lesson.id} was successfully created."
      redirect_to lessons_path
    else
      errors_message = "Lesson wasn't created! \n\n ERRORS: "
      @lesson.errors.messages.each { |k,v| errors_message += " #{k.to_s} #{v};" }
      flash[:alert] = errors_message
      @title = "All lessons"
      @students = User.only_students
      @resources = Resource.order(updated_at: :desc)
      render "new"
    end
  end

  def show
    @lesson = Lesson.find(params[:id])
    @date = params[:date].present? ? params[:date].to_date : @lesson.date_start
    @date = @lesson.date_finish if @date > @lesson.date_finish 
    @date = @lesson.date_start if @date < @lesson.date_start
    @resources = Resource.all
    @title = "Lesson #{@lesson.name}"
    render "users/diary"
  end

  def update
    @lesson = Lesson.find(params[:id])
    @comment = @lesson.comments.create(comment_params) if comment_params
    
   if @lesson.update_attributes(lesson_params)
      flash[:success] = "Lesson with id=#{@lesson.id} was successfully updated."
    else
      errors_message = "Lesson wasn't updated! \n\n ERRORS: "
      @lesson.errors.messages.each { |k,v| errors_message += " #{k.to_s} #{v};" }
      flash[:alert] = errors_message
    end 

    redirect_to :back

  end

  def destroy
    if Lesson.find(params[:id]).destroy
      redirect_to lessons_path(anchor: "lessons")
    else
      redirect_to lessons_path, alert: "Lesson wasn't successfully destroyed!"  
    end
  end

  private

    def admin_user
      redirect_to(root_path) if !current_user.admin?
    end

    def search_params
      params.permit(:user_id,:date_start,:date_finish,:raiting,:status)
    end

    def lesson_params
      if current_user.admin
        {"resource_ids" => []}
        .merge(params.require(:lesson).permit(:name,:user_id,:date_start,:date_finish,:must_be_practised,:how_to_practise,:raiting,:status,resource_ids:[]))
      else
        params.require(:lesson).permit(:status).merge(params[:lesson].reject{|k,v| v.blank? || k != "minutes_hash"})
      end

    end

    def comment_params
      params[:comment][:body].present? ? params.require(:comment).permit(:body).merge({user_id: current_user.id}) : nil
    end

    def sort_column
      (Lesson.column_names + %w[lessons.id users.name lessons.name]).include?(params[:sort]) ? params[:sort] : "lessons.id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def correct_user_or_parent_or_admin
      @user = Lesson.find(params[:id]).user
      @parent = @user.parent
      unless current_user?(@user) || current_user.admin? || current_user?(@parent)
        flash[:alert] = "You are not authorised to view this page."
        redirect_to(root_path) 
      end
    end

end