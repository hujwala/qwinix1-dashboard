require 'rails_helper'

RSpec.describe Admin::UpdatesController, :type => :controller do
  let(:user) {FactoryGirl.create(:user)}

let(:update) {FactoryGirl.create(:dashboard,:name => "update")}

before(:each) do
   session[:user_id] = user.id
 end


  it "should create update" do
    update_params = {
        widget_name: "Mystring",
        description: "about some topic"

      
    }
    post :create, update_params
    expect(QwinixUpdates.count).to eq 1
end





end
