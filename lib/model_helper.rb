module ModelHelper
	def set_model_attributes(name, model_attributes)
		model_attributes.each do |attributes|
		  if attributes[:id].blank?
		    send(name).build(attributes)
		  else
		    model = send(name).detect {|t| t.id == attributes[:id].to_i}
		    model.attributes = attributes
		  end
		end
	end

	def save_models(name)
		send(name).each do |m|
		  if m.should_destroy?
		    m.destroy
		  else
		    m.save(false)
		  end
		end
	end
end
#def save_phones() save_models(:phones); end
#def save_emails() save_models(:emails); end

#def email_attributes=(attributes) set_model_attributes(:emails, attributes); end
#def phone_attributes=(attributes) set_model_attributes(:phones, attributes); end
