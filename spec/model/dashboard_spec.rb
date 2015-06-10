require 'rails_helper'
RSpec.describe Dashboard, :type => :model do

  describe Dashboard do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end

  context "Associations" do
   it { should have_many(:dashboard_widgets) }
   it { should have_many(:widgets).through(:dashboard_widgets)}
end
end

