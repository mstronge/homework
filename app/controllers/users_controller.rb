class UsersController < ApplicationController


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

end
