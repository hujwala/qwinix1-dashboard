module Dashing
  class DashboardsController < ApplicationController
    require 'octokit'
    require 'httparty'
    require 'net/http'
    require 'json'
    require 'jira'
    require 'time'

    before_filter :check_dashboard_name, only: :show

    rescue_from ActionView::MissingTemplate, with: :template_not_found

    def index
      get_the_job_done(params[:dashboard_id])
      render file: dashboard_path(Dashing.config.default_dashboard || Dashing.first_dashboard || ''), layout: Dashing.config.dashboard_layout_path
    end

    def show
      render file: dashboard_path(params[:name]), layout: Dashing.config.dashboard_layout_path
    end

    private

    def check_dashboard_name
      raise 'bad dashboard name' unless params[:name] =~ /\A[a-zA-z0-9_\-]+\z/
    end

    def dashboard_path(name)
      Dashing.config.dashboards_views_path.join(name)
    end

    def template_not_found
      raise "Count not find template for dashboard '#{params[:name]}'. Define your dashboard in #{dashboard_path('')}"
    end

    def get_the_job_done(id)
      @json_obj = []
      dashboard = Dashboard.find id
      dashboard.dashboard_widgets.each do |dash_wid|
        @json_obj << JSON.parse(dash_wid.to_json).compact
      end   
      @json_obj.each do |obj|
        case (Widget.find obj["widget_id"]).name
        when "Github-Open-PR"
          github_open_pr_job(obj)
        when "Github-Closed-PR"
          github_closed_pr_job(obj)
        when "GPA"
          gpa(obj)
        when "Github-Status"
          github_status(obj)
        when "Sprint-progress"
          sprint_progress(obj)
        when "Sprint-remaning-days"
          sprint_remaining_days(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "To-Do-list"
        #   github_open_pr_job(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "Assign-to-QA"
        #   github_open_pr_job(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "Sprint-remaning-day"
        #   github_open_pr_job(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "Sprint-progress"
        #   github_open_pr_job(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "No of open-issues"
        #   github_open_pr_job(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "GPA"
        #   github_open_pr_job(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "Test-coverage"
        #   github_open_pr_job(obj)
        # when (Widget.find json_obj.first["widget_id"]).name = "Build-test"
        #   github_open_pr_job(obj)
      end
    end
  end

  def github_open_pr_job(obj)
    Dashing.scheduler.every '5m', :first_in => 0 do |job|
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
        pulls[0..3]
      }
      Dashing.send_event("open_pr_#{obj['dashboard_id']}", { header: "Open Pull Requests", pulls: open_pull_requests })
    end
  end

  def github_closed_pr_job(obj)
    Dashing.scheduler.every '5m', :first_in => 0 do |job|
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
        pulls[0..3]
      }

      Dashing.send_event("closed_pr_#{obj['dashboard_id']}", { header: "Closed Pull Requests", pulls: closed_pull_requests })
    end
  end

  def github_status(obj)
    @traffic_lights = {
      'good' => 'green',
      'minor' => 'amber',
      'major' => 'red'
    }
      # GITHUB_STATUS_URI = obj["github_url"].to_str
      Dashing.scheduler.every '10s', :first_in => 0 do
        response = HTTParty.get("https://status.github.com/api/last-message.json")
        data = {
          status: @traffic_lights[response["status"]],
          message: response["body"]
        }
        Dashing.send_event("traffic-lights_#{obj['dashboard_id']}", data)
      end
    end

    def gpa(obj)
      Dashing.scheduler.every '10s', :first_in => 0 do |job|
        uri = URI.parse("https://codeclimate.com/api/repos/#{obj['code_repo_id']}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        request.set_form_data({api_token: obj['code_api_token']})
        response = http.request(request)
        stats = JSON.parse(response.body)
        current_gpa = stats['last_snapshot']['gpa'].to_f
        app_name = stats['name']
        covered_percent = stats['last_snapshot']['covered_percent'].to_f
        last_gpa = stats['previous_snapshot']['gpa'].to_f
        Dashing.send_event("code-climate_#{obj['dashboard_id']}", {current: current_gpa, last: last_gpa, name: app_name, percent_covered: covered_percent })
      end   
    end

    def sprint_progress(obj)
      Dashing.scheduler.every '10s', :first_in => 0 do |job|
        @client = JIRA::Client.new({
          :username => obj["jira_name"],
          :password => obj["jira_password"],
          :site => obj["jira_url"] + "?rapidView=" +  obj["jira_view_id"],
          :auth_type => :basic,
          :context_path => ""
          })
        closed_points = @client.Issue.jql("sprint in openSprints() and status = \"Done\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
        total_points = @client.Issue.jql("sprint in openSprints()").map{ |issue| issue.fields['customfield_10004'] }.compact.reduce(:+) || 0

        if total_points == 0
          percentage = 0
          moreinfo = "No sprint currently in progress"
        else
          percentage = ((closed_points/total_points)*100).to_i
          moreinfo = "#{closed_points.to_i} / #{total_points.to_i}"
        end

        Dashing.send_event("sprint_progress_#{obj['dashboard_id']}", { title: "Sprint Progress", min: 0, value: percentage, max: 100, moreinfo: moreinfo })
      end
    end

    def sprint_remaining_days(obj)
      @jira_uri = URI.parse(obj["jira_url"])

      @jira_auth = {
        'name' => obj["jira_name"],
        'password' => obj["jira_password"]
      }

      view_mapping = {
        "view#{obj['dashboard_id']}" => { :view_id => obj["jira_view_id"].to_i },
      }

      def get_view_for_viewid(view_id)
        http = create_http
        request = create_request("/rest/greenhopper/1.0/rapidviews/list")
        response = http.request(request)
        views = JSON.parse(response.body)['views']
        views.each do |view|
          if view['id'] == view_id
            return view
          end
        end
      end

      def get_active_sprint_for_view(view_id)
        http = create_http
        request = create_request("/rest/greenhopper/1.0/sprintquery/#{view_id}")
        response = http.request(request)
        sprints = JSON.parse(response.body)['sprints']
        sprints.each do |sprint|
          if sprint['state'] == 'ACTIVE'
            return sprint
          end
        end
      end

      def get_remaining_days(view_id, sprint_id)
        http = create_http
        request = create_request("/rest/greenhopper/1.0/gadgets/sprints/remainingdays?rapidViewId=#{view_id}&sprintId=#{sprint_id}")
        response = http.request(request)
        JSON.parse(response.body)
      end

      def create_http
        http = Net::HTTP.new(@jira_uri.host, @jira_uri.port)
        if ('https' == @jira_uri.scheme)
          http.use_ssl     = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        return http
      end

      def create_request(path)
        request = Net::HTTP::Get.new(@jira_uri.path + path)
        if @jira_auth['name']
          request.basic_auth(@jira_auth['name'], @jira_auth['password'])
        end
        return request
      end

      view_mapping.each do |view, view_id|
        Dashing.scheduler.every '10s', :first_in => 0 do |id|
          view_name = ""
          sprint_name = ""
          days = ""
          view_json = get_view_for_viewid(view_id[:view_id])
          if (view_json)
            view_name = view_json['name']
            sprint_json = get_active_sprint_for_view(view_json['id'])
            if (sprint_json)
              sprint_name = sprint_json['name']
              days_json = get_remaining_days(view_json['id'], sprint_json['id'])
              days = days_json['days']
            end
          end
          Dashing.send_event(view, {
            viewName: view_name,
            sprintName: sprint_name,
            daysRemaining: days
            })
        end
      end
    end
  end
end