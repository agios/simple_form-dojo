require 'set'

module SimpleFormDojo
  module DojoPropsMethods

    FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set
    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set

    # need to include this in order to 
    # get the html_escape method
    include ERB::Util

    ##
    # Retrieves and merges all dojo_props
    def get_and_merge_dojo_props!
      add_dojo_options_to_dojo_props 
      add_attributes_to_dojo_props
      add_dojo_compliant_id if object.id.present?
      # input_html_options[:'data-dojo-props'] = @builder.encode_as_dojo_props(@dojo_props) if !@dojo_props.blank?
      input_html_options[:'data-dojo-props'] = SimpleFormDojo::FormBuilder.encode_as_dojo_props(@dojo_props) if !@dojo_props.blank?
    end

    private 

    ##
    # Retrieves dojo props from :dojo_html => {} options 
    def add_dojo_options_to_dojo_props
      @dojo_props ||= {}
      @dojo_props.merge!(html_options_for(:dojo, []))
    end

    ##
    # Using data-dojo-props with Dojo 1.6.0+ 
    # requires adding attributes such as name, value, class, etc. 
    # into the data-dojo-props attribute in order for them to be 
    # properly parsed by dojo when reading the attribute line
    # See: http://bugs.dojotoolkit.org/ticket/11490
    def add_attributes_to_dojo_props
      @dojo_props ||= {}
      add_name_to_dojo_props 
      add_type_to_dojo_props
      add_value_to_dojo_props
    end

    ##
    # Follows the same basic routines as rails does 
    # to determine the name of the tag 
    def add_name_to_dojo_props
      opts = input_html_options
      if opts.has_key?("index")
        @dojo_props[:name] ||= dojo_tag_name_with_index(opts["index"])
      else
        @dojo_props[:name] ||= dojo_tag_name + (add_multiple_to_name?(opts) ? '[]' : '')
      end
    end

    ##
    # Determines if this name should include multiple options
    def add_multiple_to_name?(options)
      options.has_key?(:multiple) || 
        input_type == :check_boxes
    end

    ## 
    # Get the dojo input type 
    def add_type_to_dojo_props
      dtype = nil
      unless [:text].include?(input_type)
        case input_type
        when :password
          dtype = 'password'
        when :check_boxes, :checkbox
          dtype = 'checkbox'
        when :boolean, :radio, :radio_buttons
          dtype = 'radio'
        else
          dtype = 'text'
        end
      end
      @dojo_props[:type] = dtype unless dtype.nil? 
    end

    def dojo_tag_name
      "#{object_name}[#{sanitized_attribute_name}]"
    end

    def dojo_tag_name_with_index(index)
      "#{object_name}[#{index}][#{sanitized_attribute_name}]"
    end

    def add_value_to_dojo_props
      unless [:text, :text_simple].include?(input_type) 
        opts = input_html_options
        @dojo_props[:value] = opts.fetch("value") { value_before_type_cast(object, attribute_name) } unless input_type == "file"
        #char_subs = {
          #"'" => ""
        #}
        # @dojo_props[:value] &&= html_escape(@dojo_props[:value]).gsub(/\'/, char_subs )
        @dojo_props[:value] &&= html_escape(@dojo_props[:value])
        @dojo_props.delete(:value) if @dojo_props[:value].nil?
      end
    end

    def value_before_type_cast(object, object_name)
      unless object.nil?
        value = object.respond_to?(attribute_name.to_s + "_before_type_cast") ? 
                  object.send(attribute_name.to_s + "_before_type_cast") :
                  object.send(attribute_name.to_s)
        type = column.try(:type)
        case type
        when :boolean
          return (value.is_a?(String) && value.blank? ? nil : TRUE_VALUES.include?(value))
        else
          if self.is_a? SimpleForm::Inputs::CollectionInput
            return value
          else
            return value
          end
        end
      end
    end

    def tag_id index = nil
      id = sanitized_object_name
      id << "_#{object.id}"
      id << index if index
      id << "_#{sanitized_attribute_name}"
      id
    end

    def add_dojo_compliant_id
      opts = input_html_options
      if opts.has_key?("index")
        opts["id"] = opts.fetch("id"){ tag_id opts["index"] }
        opts.delete("index")
      elsif defined?(@auto_index)
        opts["id"] = opts.fetch("id"){ tag_id @auto_index }
      else
        opts["id"] = opts.fetch("id"){ tag_id }
      end
    end

    def sanitized_attribute_name
      @sanitized_attribute_name ||= attribute_name.to_s.sub(/\?$/,"")
    end

    def sanitized_object_name
      @sanitized_object_name ||= object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end
  end
end
