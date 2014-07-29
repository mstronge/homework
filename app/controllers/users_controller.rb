class UsersController < ApplicationController


  def show
  	@user = User.find(params[:id])
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
  	if @user.save
  		flash[:success] = "Thank you for signing up, your teacher will be in touch."
  		redirect_to @user
  	else
  	@title = "Sign up"
  	render 'new'
  	end
  end

end
