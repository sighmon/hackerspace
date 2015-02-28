module ApplicationHelper

	def bootstrap_class_for flash_type
		case flash_type
			when :success
				"alert-success"
			when :error
				"alert-danger"
			when :alert
				"alert-warning"
			when :notice
				"alert-info"
			else
				# flash_type.to_s
				"alert-info"
		end
	end
	
	def memberships_as_table(memberships)
		if memberships.try(:empty?)
			return "You don't have any memberships."
		else
			table = "<table class='table table-bordered purchases_as_table'><thead><tr><th>Purchase date</th><th>Valid from</th><th>Duration</th><th>Autodebit?</th><th>Concession</th><th>Cancelled?</th><th>Price paid</th></tr></thead><tbody>"
			for membership in memberships.sort_by {|x| x.purchase_date} do
				table += "<tr><td>#{membership.purchase_date.try(:strftime,"%d %B, %Y")}</td>"
				table += "<td>#{membership.valid_from.try(:strftime,"%d %B, %Y")}</td>"
				table += "<td>#{membership.duration}</td>"
				# table += "<td>#{membership.cancellation_date.try(:strftime,"%d %B, %Y")}</td>"
				table += "<td>#{membership.was_recurring? ? "#{membership.paypal_profile_id}" : "No"}</td>"
				table += "<td>#{membership.concession? ? "Yes" : "No"}</td>"
				table += "<td>#{membership.cancellation_date ? membership.cancellation_date.strftime("%d %B, %Y") : "No" }</td>"
				table += "<td>#{membership.price_paid ? "$#{number_with_precision((membership.price_paid / 100), :precision => 2)}" : "Free"}</td>"
				# table += "<td>#{membership.refund ? "$#{cents_to_dollars(membership.refund)}" : ""}</td>"
				# table += "<td>#{membership.refunded_on ? "#{membership.refunded_on.try(:strftime,"%d %B, %Y")} #{link_to('Undo?', admin_membership_path(membership), :method => :put, :class => 'btn btn-mini btn-success', :confirm => 'Are you sure you want to undo marking it refunded?')}" : "#{link_to('Refunded', admin_membership_path(membership), :method => :put, :class => 'btn btn-mini btn-danger', :confirm => 'Are you sure you want to mark this refund as paid?')}" }</td></tr>"
			end
			table += "</tbody></table>"
			return raw table
		end
	end

	def pretty_membership_price(duration, options = {})
		return number_with_precision((Membership.calculate_membership_price(duration, options) / 100), :precision => 2)
	end

	def website_clickable(user)
		url = user.website
		sanitize url
		if not url.include?('http://')
			url = "http://#{url}"
		end
		link_to url.gsub(/http:\/\//, '').gsub(/www./, ''), "#{url}"
	end
end
