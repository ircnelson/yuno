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
end
