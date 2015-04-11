# Set up gems listed in the Gemfile.
# ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require File.expand_path(__FILE__)+ '/../../config/boot'

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
