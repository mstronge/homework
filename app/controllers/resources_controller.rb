class ResourcesController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :authenticate, :only => [:index]
  before_filter :admin_user,   :only => [:destroy, :create]

  def index
    @resources = Resource.order(sort_column + " " + sort_direction) #.paginate(:page => params[:page], :per_page => 50)
    @title = "Resource Area"
  end

  def create
    @resource = Resource.new(resource_params)  
    if @resource.save
      redirect_to resources_path(anchor: "resource_#{@resource.id}")
      flash[:success] = "Resource with id=#{@resource.id} was successfully created."
    else
      errors_message = "Resource wasn't created! \n\n ERRORS: "
      @resource.errors.messages.each { |k,v| errors_message += " #{k.to_s} #{v};" }
      redirect_to resources_path
      flash[:alert] = errors_message
    end
  end

  def destroy
    if Resource.find(params[:id]).destroy
      redirect_to resources_path(anchor: "resources")
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

    def authenticate
      deny_access unless signed_in?
    end

    def sort_column
      (Resource.column_names).include?(params[:sort]) ? params[:sort] : "id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
