class Widget < ActiveRecord::Base

  has_many :dashboard_widgets
  has_many :dashboards, through: :dashboard_widgets

end
