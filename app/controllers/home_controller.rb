class HomeController < ApplicationController
	def index
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
end
