class DashboardWidget < ActiveRecord::Base

  belongs_to :dashboard
  belongs_to :widget

  def savewidgets(widgets, dashboard)
    widgets.each do |wid|
      @dashboard_widget = DashboardWidget.new
      @dashboard_widget.widget_id = wid
      @dashboard_widget.dashboard_id = dashboard.id
      @dashboard_widget.save if @dashboard_widget.valid?
    end
  end
  
end
