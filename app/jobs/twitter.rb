# #!/usr/bin/env ruby
# require 'nokogiri'
# require 'open-uri'

# # Track public available information of a twitter user like follower, follower
# # and tweet count by scraping the user profile page.

# # Config
# # ------
# twitter_username = ENV['Qwinix'] || 'foobugs'

# Dashing.scheduler.every '1s', :first_in => 0 do |job|
# 	doc = Nokogiri::HTML(open("https://twitter.com/#{twitter_username}"))
# 	tweets = doc.css('a[data-nav=tweets]').first.attributes['title'].value.split(' ').first
# 	followers = doc.css('a[data-nav=followers]').first.attributes['title'].value.split(' ').first
# 	following = doc.css('a[data-nav=following]').first.attributes['title'].value.split(' ').first

# 	Dashing.send_event('twitter_user_followers', current: tweets)
# 	Dashing.send_event('twitter_user_followers', current: followers)
# 	Dashing.send_event('twitter_user_followers', current: following)
# end	