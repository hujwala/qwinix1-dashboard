module Dashing
  class DashboardsController < ApplicationController
    require 'octokit'
    require 'httparty'
    require 'net/http'
    require 'json'
    require 'jira'
    require 'time'

    include GitHub
    include CodeClimate
    include Jira

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
          when "Jira Stories Details"
            number_of_open_issues(obj)
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
  end
end