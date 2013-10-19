class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def retrieve_paypal_express_details(token, options = {})
    autodebit = options[:autodebit] or false
    if autodebit
      ppr = PayPal::Recurring.new(:token => token)
      details = ppr.checkout_details
      session[:express_payer_id] = details.payer_id
      session[:express_email] = details.email
      session[:express_first_name] = details.first_name
      session[:express_last_name] = details.last_name
      session[:express_country_code] = details.country
    else
      details = EXPRESS_GATEWAY.details_for(token)
      session[:express_payer_id] = details.payer_id
      session[:express_email] = details.email
      session[:express_first_name] = details.params["first_name"]
      session[:express_last_name] = details.params["last_name"]
      session[:express_street1] = details.params["street1"]
      session[:express_street2] = details.params["street2"]
      session[:express_city_name] = details.params["city_name"]
      session[:express_state_or_province] = details.params["state_or_province"]
      session[:express_country_name] = details.params["country_name"]
      session[:express_postal_code] = details.params["postal_code"]
    end
    #logger.info "******"
    #logger.info details.params
    #logger.info "******"
  end
  
end
