require 'rails_helper'

RSpec.describe Admin::DashboardWidgetsController, :type => :controller do
 
  let(:user) {FactoryGirl.create(:user)}


let(:widgets) {FactoryGirl.create(:widget)}
let(:jira_widgets) {FactoryGirl.create(:jira_widgets)}
let(:code_widgets) {FactoryGirl.create(:code_widgets)}
let(:jenkins_widgets) {FactoryGirl.create(:jenkins_widgets)}
let(:newreli_widgets) {FactoryGirl.create(:newreli_widgets)}

let(:dashboard) {FactoryGirl.create(:dashboard)}
let(:dashboard_widget) {FactoryGirl.create(:dashboard_widget)}

before(:each) do
   session[:user_id] = user.id
 end

 describe "GET #new" do
  it "assigns a new Widget to @widget" do
    expected_result=[widgets,jira_widgets,code_widgets,jenkins_widgets,newreli_widgets]
    xhr :get, :new, {:dashboard_id =>dashboard.id}
    assigns(:widgets).should eq(expected_result)
    assigns(:github_widgets).should eq([widgets])
    assigns(:jira_widgets).should eq([jira_widgets])
    assigns(:code_widgets).should eq([code_widgets])
    assigns(:jenkins_widgets).should eq([jenkins_widgets])
    assigns(:newreli_widgets).should eq([newreli_widgets])
  end
end

  
  it "should allow user to edit dashboard"do
   dashboard
   dashboard_widget
   xhr :get, :edit,{:dashboard_id =>dashboard.id}
 end 


end
