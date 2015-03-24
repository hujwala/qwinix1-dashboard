require 'jira'
 
host = "https://qwinix.atlassian.net"
username = "anjankumarhn"
password = "nenapu khushi"
project = "DD"
status = "OPEN"
 
options = {
            :username => username,
            :password => password,
            :context_path => '',
            :site     => host,
            :auth_type => :basic
          }
 
Dashing.scheduler.every '5s', :first_in => 0 do |job|
  
  client = JIRA::Client.new(options)
  num = 0;
 
  client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{status}\"").each do |issue|
      num+=1
      
  end

 Dashing.send_event('jira', { current: num })
end