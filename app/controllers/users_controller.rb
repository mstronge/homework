class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index]
  before_filter :correct_user_or_admin, :only => [:show, :edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @users = User.paginate(:page => params[:page], :per_page => 10)
    @title = "All users"
  end

  def show
    @title = @user.name
  end

  def new
    if signed_in?
      redirect_to root_path
      flash[:success] = "You are already signed in."
    end
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.admin = false
    if @user.save
      flash[:success] = "Thank you, #{@user.name}, for signing up, your teacher will be in touch."
      redirect_to root_path
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @parents = User.only_parents
    @title = "Edit account details"
  end

  def update
    @parents = User.only_parents

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :flash => { :success => "Account Details have been changed."} }
        format.js { render js: 'alert("sdf")' }
      else
        format.html { render action: 'edit' }
        #format.json { render json: @mailing.errors, status: :unprocessable_entity }
      end
    end



    #if @user.update_attributes(params[:user])
      #respond_to do |format|
      #redirect_to @user, :flash => { :success => "Account Details have been changed."}
    #else
      #@title = "Edit account details"
      #render 'edit'
    #end

  end

  def destroy
    @name_deleted_user = @user.name
    @user.destroy
    redirect_to users_path, :flash => { :alert => "User #{@name_deleted_user} has been deleted."}
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user_or_admin
      @user = User.find(params[:id])
      unless current_user?(@user) || current_user.admin?
        redirect_to(root_path)
        flash[:alert] = "You are not authorised to view this page."
      end
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(@user)
    end

end