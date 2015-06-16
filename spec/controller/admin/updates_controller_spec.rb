require 'rails_helper'

RSpec.describe Admin::UpdatesController, :type => :controller do
  let(:user) {FactoryGirl.create(:user)}

let(:update) {FactoryGirl.create(:qwinix_update)}
let(:update_1) {FactoryGirl.create(:qwinix_update)}
let(:update_2) {FactoryGirl.create(:qwinix_update)}

before(:each) do
   session[:user_id] = user.id
 end


 describe "GET index" do
    it "list all company updates" do
      get :index
      binding.pry
      assigns(:qwinix_update).should eq(update)
    end
  end




end
