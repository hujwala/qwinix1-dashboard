require 'rails_helper'

RSpec.describe Widget, type: :model do
context "Associations" do
   it { should have_many(:dashboard_widgets) }
   it { should have_many(:dashboards).through(:dashboard_widgets)}
 end
end
