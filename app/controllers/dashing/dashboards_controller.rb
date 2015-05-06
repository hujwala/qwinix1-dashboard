module Dashing
  class DashboardsController < ApplicationController
    require 'octokit'
    require 'httparty'
    require 'net/http'
    require 'json'
    require 'jira'

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


  end
end