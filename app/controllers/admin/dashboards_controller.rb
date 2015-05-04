 class Admin::DashboardsController < ApplicationController
  before_filter :require_login

  def index
    get_collections
  end

  def new
    @dashboard = Dashboard.new
  end

  def create
    @dashboard = Dashboard.new(dashboard_params)
    if @dashboard.valid?
      @dashboard.save
      @success = true
      flash[:success] = "Dashboard created successfully!"
    else
      @success = false
    end
    @dashboards = Dashboard.order("updated_at desc").paginate(:page => params[:page], :per_page => 4)
  end

  def edit
    @dashboard = Dashboard.find(params[:id])
  end

  def show
    @dashboard = Dashboard.find(params[:id])
  end

  def update
    @dashboard = Dashboard.find(params[:id])
    @dashboards = Dashboard.order("updated_at desc").paginate(:page => params[:page], :per_page => 4)
    @dashboard.update_attributes(dashboard_params)
    if @dashboard.valid?
      @success = true
      flash[:success] = "Dashboard updated successfully!"
    else
      @success = false
    end
  end

  def destroy
    @dashboard = Dashboard.find(params[:id])
    @dashboardwidgets = DashboardWidget.where(dashboard_id: params[:id])
    @dashboardwidgets.destroy_all
    @dashboard.destroy
    @dashboards = Dashboard.order("updated_at desc").paginate(:page => params[:page], :per_page => 4)
    redirect_to admin_dashboards_path
    flash[:notice] = "Dashboard deleted successfully!"
  end

  private

  def dashboard_params
    params[:dashboard].permit(:name)
  end

  def get_collections
    # Fetching the dashboard
    relation = Dashboard.where("")
    @filters = {}
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    @dashboards = relation.order("updated_at desc")
    @dashboards = Dashboard.order("updated_at desc").paginate(:page => params[:page], :per_page => 4)
    ## Initializing the @dashboard object so that we can render the show partial
    @dashboard = @dashboards.first unless @dashboard
    return true
  end

end