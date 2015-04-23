module ApplicationHelper
	require 'octokit'

	def github_pr_job
	Dashing.scheduler.every '10s', :first_in => 0 do |job|
	  client = Octokit::Client.new(:access_token => "e59c0de446ffe9901e75db5e76ce4ec2a75c89c7")
	  my_organization = "Qwinix"
	  repos = client.organization_repositories(my_organization).map { |repo| repo.name }

	  open_pull_requests = repos.inject([]) { |pulls, repo|
	    client.pull_requests("#{my_organization}/#{repo}", :state => 'close').each do |pull|
	      if repo=="docdock"
	      pulls.push({
	        title: pull.title,
	        repo: repo,
	        updated_at: pull.updated_at.strftime("%b %-d %Y, %l:%m %p"),
	        creator: "@" + pull.user.login,
	        })
	      end
	    end
	    pulls
	  }

	  Dashing.send_event('AuthToken', { header: "Open Pull Requests", pulls: open_pull_requests })
	end
	end
end
