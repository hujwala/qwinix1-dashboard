require 'rails_helper'

RSpec.describe Admin::UsersController, :type => :controller do

let(:user) {FactoryGirl.create(:user)}
let(:user_1) {FactoryGirl.create(:user)}
let(:user_2) {FactoryGirl.create(:user)}

before(:each) do
   session[:user_id] = user.id
 end

it "should create user" do

     user_params = {
       user: {
         name: "user_name",
         email: "email@gmail.com",
         password: "Password@1",
         password_confirmation: "Password@1"
       }
     }
     post :create, user_params
     expect(User.count).to  eq 2
   end
   describe "GET index" do
    it "list all user" do
    	[user,user_1,user_2]
      get :index
      assigns(:users).should eq([user_2,user_1,user])
    end
  end

end