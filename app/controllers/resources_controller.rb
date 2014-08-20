class ResourcesController < ApplicationController
  
  before_filter :admin_user,   :only => [:destroy, :create, :update]

  def index
    @resources = Resource.order(updated_at: :desc).paginate(:page => params[:page], :per_page => 2)
    @title = "Resource Area"
  end

  def create
    @resource = Resource.new(resource_params)
  
    if @resource.save
      flash[:success] = "Resource with id=#{@resource.id} was successfully created."
    else
      errors_message = "Resource wasn't created! \n\n ERRORS: "
      @resource.errors.messages.each { |k,v| errors_message += " #{k.to_s} #{v};" }
      flash[:alert] = errors_message
    end

    redirect_to resources_path

  end

  def destroy
    if Resource.find(params[:id]).destroy
      render js: "$('#resource_#{params[:id]}').remove()" 
    else
      redirect_to resources_path, alert: "Resource wasn't successfully destroyed!"  
    end
  end

  private

    def resource_params
      params.require(:resource).permit(:attachment,:tag,:link)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
