class Dashboard < ActiveRecord::Base

	has_many :dashboard_widgets
	has_many :widgets, through: :dashboard_widgets
	validates :name, presence: true
	validates_uniqueness_of :name
end
