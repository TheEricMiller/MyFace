module ApplicationHelper

	def status_document_link(status)
		if status.document && status.document.attachment?
			content_tag(:span, "Attachment", class: "label label-info") + 
			" " + link_to(status.document.attachment_file_name, status.document.attachment.url)
		end
	end

	def can_display_status?(status)
		signed_in? && !current_user.has_blocked?(status.user) || !signed_in?
	end

	def avatar_profile_link(thisuser, image_options={}, html_options={})
		avatar_url = thisuser.avatar? ? thisuser.avatar.url(:thumb) : thisuser.gravatar_url #nil
		link_to(image_tag(avatar_url, image_options), profile_path(thisuser.profile_name), html_options)
	end

	def flash_class(type)
		case type
		when :alert
			"alert-error"
		when :notice
			"alert-success"
		else
			""
		end
	end

end
