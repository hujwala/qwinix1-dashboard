FactoryGirl.define do
  factory :dashboard_widget do
   access_token "12345"
   organization_name "qwinix"
   repo_name "loan"
   status "open"
   github_url ""
   jira_url "https://qwinix.atlassian.net"
   jira_view_id "77"
   jira_name "akumar"
   jira_password "Qwinix123"
   code_repo_id  "5508fdbe695680039a004191"
   code_api_token "255887c05d5a64ea167e4d3455f63d8f71574536"
   jira_project_key "LOAN"
   github_status_prs "open"
   jenkins_name "Sasikumar"
   jenkins_password "Qwinix2015!"
   jenkins_url "http://jenkins.qwinixtech.com:8000/view/Loan%20List%20Project%20Pipeline/"
  end
end
