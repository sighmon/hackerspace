class HomeController < ApplicationController
	def index
		@checked_in_users = []
		@session_on = is_session_on?

		Checkin.all.each do |checkin|
			if checkin.created_at >= DateTime.now.in_time_zone('Adelaide').beginning_of_day
				# @checked_in_users.push(checkin.user.username) unless @checked_in_users.include?(checkin.user.username)
				@checked_in_users << checkin.user.username
			end
		end

		if not @checked_in_users.empty?
			@checked_in_users = @checked_in_users.join(", ")
		else
			@checked_in_users = "Nobody has checked in yet."
		end
		

		@page_title_home = "Hackerspace Adelaide Membership Website"
		@page_description = "Join Hackerspace Adelaide today to have access to many minds, tools, and help us grow the community."

		set_meta_tags :description => @page_description,
						:keywords => "hackerspace, adelaide, australia, hack, electronics, tinker, 3d printer",
						:open_graph => {
							:title => @page_title_home,
							:description => @page_description,
							:url   => root_url,
							:image => "#{request.protocol}#{request.host_with_port}" + ActionController::Base.helpers.asset_path('hackerspace-adelaide-logo@2x.png'),
							:site_name => "Hackerspace Adelaide Membership Website"
						},
						:twitter => {
							:card => "summary",
							:site => "@hackadl",
							:creator => "@hackadl",
							:title => @page_title_home,
							:description => @page_description,
							:image => {
								:src => "#{request.protocol}#{request.host_with_port}" + ActionController::Base.helpers.asset_path('hackerspace-adelaide-logo@2x.png')
							}
						}
	end

	def who
		if is_session_on?
			checkins_today = Checkin.where("created_at >= ?", DateTime.now.in_time_zone('Adelaide').beginning_of_day)
			users_checked_in = []
			checkins_today.each do |c|
				minimal_user_details = {}
				minimal_user_details[:username] = c.user.username
				minimal_user_details[:checked_in_at] = c.created_at
				users_checked_in << minimal_user_details
			end

			render json: users_checked_in
		else
			render json: nil
		end
	end

	def is_session_on?
		today = DateTime.now.in_time_zone('Adelaide')
		session = false
		if (today.wday == 6) and (today.hour > 12 and today.hour < 17)
			session = true
		elsif ((today.wday == 3) or (today.wday == 2)) and (today.hour > 17 and today.hour < 22)
			session = true
		end
		session
	end
end
