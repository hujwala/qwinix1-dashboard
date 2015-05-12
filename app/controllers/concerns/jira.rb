module Jira
  extend ActiveSupport::Concern
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