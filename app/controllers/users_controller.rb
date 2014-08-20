class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :show]
  before_filter :correct_user, :only => [:edit, :update, :show]
  before_filter :admin_user,   :only => :destroy

  def index
    @users = User.paginate(:page => params[:page], :per_page => 5)
    @title = "All users"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @current_user = @user
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
  	if @user.save
  		flash[:success] = "Thank you for signing up, your teacher will be in touch."
  		redirect_to @user
  	else
  	@title = "Sign up"
  	render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit account details"

  end

  def update
    @user = User.find(params[:id])    
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Account Details have been changed."}
    else
      @title = "Edit account details"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success => "User has been deleted."}
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
      flash[:alert] = "You are not authorised to view this page."  unless current_user?(@user)
    end

    def admin_user
      user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(user)
    end

end