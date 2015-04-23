module ApplicationHelper
	require 'octokit'
	require 'httparty'

	def get_the_job_done(id)
		json_obj = []
		dashboard = Dashboard.find id
		dashboard.dashboard_widgets.each do |dash_wid|
			json_obj << JSON.parse(dash_wid.to_json).compact
		end		
		json_obj.each do |obj|
			case obj
			when (Widget.find json_obj.first["widget_id"]).name = "Github-Open-PR"
				github_open_pr_job(obj)
			when (Widget.find json_obj.first["widget_id"]).name = "Github-Closed-PRR"
				github_closed_pr_job(obj)
			when (Widget.find json_obj.first["widget_id"]).name = "Github-Status"
				github_status(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "Github-Last-10-Commits"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "To-Do-list"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "Assign-to-QA"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "Sprint-remaning-day"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "Sprint-progress"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "No of open-issues"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "GPA"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "Test-coverage"
			# 	github_open_pr_job(obj)
			# when (Widget.find json_obj.first["widget_id"]).name = "Build-test"
			# 	github_open_pr_job(obj)
			end
		end
	end

	def github_open_pr_job(obj)
		Dashing.scheduler.every '10m', :first_in => 0 do |job|
		  client = Octokit::Client.new(:access_token => obj["access_token"])
		  my_organization = obj["organization_name"]
		  repos = client.organization_repositories(my_organization).map { |repo| repo.name }

		  open_pull_requests = repos.inject([]) { |pulls, repo|
		      if repo==obj["repo_name"]
		    		client.pull_requests("#{my_organization}/#{repo}", :state => 'open').each do |pull|
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

		  Dashing.send_event('open_pr', { header: "Open Pull Requests", pulls: open_pull_requests })
		end
	end

	def github_closed_pr_job(obj)
		Dashing.scheduler.every '10m', :first_in => 0 do |job|
		  client = Octokit::Client.new(:access_token => obj["access_token"])
		  my_organization = obj["organization_name"]
		  repos = client.organization_repositories(my_organization).map { |repo| repo.name }

		  closed_pull_requests = repos.inject([]) { |pulls, repo|
		    client.pull_requests("#{my_organization}/#{repo}", :state => 'close').each do |pull|
		      if repo==obj["repo_name"]
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

		  Dashing.send_event('closed_pr', { header: "Closed Pull Requests", pulls: closed_pull_requests })
		end
	end

	def github_status(obj)
		self.GITHUB_STATUS_TO_TRAFFIC_LIGHT_MAP = {
		  'good' => 'green',
		  'minor' => 'amber',
		  'major' => 'red'
		}
		self.GITHUB_STATUS_URI = obj["github_url"]

		Dashing.scheduler.every '10m', :first_in => 0 do
		  response = HTTParty.get(self.GITHUB_STATUS_URI)
		  data = {
		    status: self.GITHUB_STATUS_TO_TRAFFIC_LIGHT_MAP[response["status"]],
		    message: response["body"]
		  }
		  Dashing.send_event('github_status', data)
		end
	end

	def github_last_10_commits
		
	end

	def method_name
		
	end

	def method_name
		
	end
end
