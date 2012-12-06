# Load the rails application
require File.expand_path('../application', __FILE__)

Shop::Application.configure do
	config.action_mailer.delivery_method = :smtp
	config.action_mailer.smtp_settings = {
		address:		"smtp.gmail.com",
		port:		587,
		domain:		"",
		authentication: "plain",
		user_name:		"sandy.pierre97@gmail.com",
		password:		"epicure971",
		enable_starttls_auto: true
	}
end


# Initialize the rails application
Shop::Application.initialize!
