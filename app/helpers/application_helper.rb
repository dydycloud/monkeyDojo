module ApplicationHelper
	def hidden_div_if(condition, attributes = {}, &block)
		if condition
			attributes["style"] = "display: none"
		end
		content_tag("a", attributes, &block)
	end
end
