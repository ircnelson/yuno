# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def admin_area(&block)
		if is_admin?
			concat content_tag(:div, capture(&block), :class => 'admin-area')
		end
	end
	
	def check_url(controller1, controller2, action = nil)
		if (controller1 == controller2)
			true
		end
	end

	def render_form(form, button)
		render :partial => form, :locals => { :btn_submit => button }
	end

	def new_render_form
		render_form('form', t('link.add'))
	end

	def edit_render_form
		render_form('form', t('link.save'))
	end
	
	def anchor(anchor)
		"<a name=\"#{anchor}\"></a>"
	end
	
	def state(s)
		bullet_g = 'icons/bullet_green.png'
		bullet_r = 'icons/bullet_red.png'
		bullet_y = 'icons/bullet_yellow.png'
		case s
			when 'suspended'
				bullet_y
			when 'pending'
				bullet_y
			when 'active'
				bullet_g
			when 'opened'
				bullet_g
			when 'deleted'
				bullet_r
			when 'closed'
				bullet_r
		end
	end
end

WillPaginate::ViewHelpers.pagination_options[:previous_label] = t('pagination.previous_label')
WillPaginate::ViewHelpers.pagination_options[:next_label] = t('pagination.next_label')
