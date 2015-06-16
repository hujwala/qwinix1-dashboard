require 'rails_helper'

RSpec.describe Admin::DashboardsController, :type => :controller do
  let(:user) {FactoryGirl.create(:user)}

let(:dashboard) {FactoryGirl.create(:dashboard,:name => "dashboard")}
let(:dashboard_1) {FactoryGirl.create(:dashboard, :name => "dashboard1")}
let(:dashboard_2) {FactoryGirl.create(:dashboard,:name => "dashboard2")}

before(:each) do
   session[:user_id] = user.id
 end


  it "should create dashboard" do
    dashboard_params = {
      dashboard: {
        name: "Mystring"

      }
    }
    post :create, dashboard_params
    expect(Dashboard.count).to eq 1
end

describe "GET index" do
    it "list all dashboard" do
      [dashboard,dashboard_1,dashboard_2]
      get :index
      assigns(:dashboards).should eq([dashboard_2,dashboard_1,dashboard])
    end
  end

  it "should allow user to edit dashboard"do
   dashboard
   xhr :get, :edit, :id => dashboard.id
 end 

 it "should allow user to show dashboard"do
   dashboard
   xhr :get, :show, :id => dashboard.id
   expect(assigns(:dashboard)).to eq dashboard
 end

 it "should allow user to update dashboard" do
   dashboard
   dashboard_params = {
      dashboard: {
        name: "loan-list"

      }
    }
    expect{
    xhr :patch , :update, :id => dashboard.id, :dashboard => {
        name: "loan-list"
    }
  }.to change{Dashboard.count}.by(0)
 end
it "should allow user to delete dashboard" do
   dashboard
   expect{

   delete :destroy, :id => dashboard.id
   }.to change{Dashboard.count}.by(-1)
 end


end
