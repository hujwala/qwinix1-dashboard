module QwinixUpdatesJob

	# extend ActiveSupport::Concern

	def view_qwinix_updates
		Dashing.scheduler.every '10s', :first_in => 0 do |job|
			@hrs = Hr.last
			Dashing.send_event("update", {title: @hrs.name1 , text: @hrs.description1 })
			
		end 
		sharedlink = URI::encode('https://www.facebook.com/qwinix')

		Dashing.scheduler.every '1m' do
			fbstat = []

			http = Net::HTTP.new('graph.facebook.com')
			response = http.request(Net::HTTP::Get.new("/fql?q=SELECT%20share_count,%20like_count,%20comment_count,%20total_count%20FROM%20link_stat%20WHERE%20url=%22#{sharedlink}%22"))
			fbcounts = JSON.parse(response.body)['data']

			fbcounts[0].each do |stat|
				fbstat << {:label=>stat[0], :value=>stat[1]}
			end
			Dashing.send_event('fblinkstat', { items: fbstat })

		end 

		twitter_username = ENV['Qwinix'] || 'foobugs'
		Dashing.scheduler.every '1m', :first_in => 0 do |job|
			doc = Nokogiri::HTML(open("https://twitter.com/#{twitter_username}"))
			tweets = doc.css('a[data-nav=tweets]').first.attributes['title'].value.split(' ').first
			followers = doc.css('a[data-nav=followers]').first.attributes['title'].value.split(' ').first
			following = doc.css('a[data-nav=following]').first.attributes['title'].value.split(' ').first

			Dashing.send_event('twitter_user_followers', current: tweets)
			Dashing.send_event('twitter_user_followers', current: followers)
			Dashing.send_event('twitter_user_followers', current: following)
		end	
	end 
end
