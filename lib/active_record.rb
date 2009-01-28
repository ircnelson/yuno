module ActiveRecord
	class Errors
    include Enumerable
    class << self
    	def full_messages(options = {})
      full_messages = []
      @errors.each_key do |attr|
        @errors[attr].each do |message|
          next unless message
          if attr == "base"
            full_messages << message
          else
            #key = :"activerecord.att.#{@base.class.name.underscore.to_sym}.#{attr}" 
            attr_name = @base.class.human_attribute_name(attr)
            full_messages << message
          end
        end
      end
      full_messages
		end
	end
end  
