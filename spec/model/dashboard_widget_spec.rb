require 'rails_helper'

RSpec.describe DashboardWidget, type: :model do
context "Associations" do
it { should belong_to(:dashboard) }
 it { should belong_to(:widget) }
 end
end
