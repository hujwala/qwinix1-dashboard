FactoryGirl.define do
  factory :widget do
     name "Github-Open-PR"
    widget_type "Github"
  end
  factory :jira_widgets, :parent => :widget do
  	name "Jira Story"
    widget_type "Jira"
  end
  factory :code_widgets, :parent => :widget do
  	name "GPA"
    widget_type "Code Climate"
  end
  factory :jenkins_widgets, :parent => :widget do
  	name "Build-test"
    widget_type "Jenkins"
  end
  factory :newreli_widgets, :parent => :widget do
  	name "Response"
    widget_type "Newrelic"
  end
end
