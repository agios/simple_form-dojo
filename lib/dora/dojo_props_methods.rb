module Dora
  module DojoPropsMethods

    # need to include this in order to 
    # get the html_escape method
    include ERB::Util

    ##
    # Retrieves and merges all dojo_props
    def get_and_merge_dojo_props!
      add_dojo_options_to_dojo_props 
      add_attributes_to_dojo_props
      input_html_options[:'data-dojo-props'] = @builder.encode_as_dojo_props(@dojo_props) if !@dojo_props.blank?
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
        # @dojo_props[:id] = opts.fetch("id") { dojo_tag_id_with_index(opts["index"]) }
      else
        @dojo_props[:name] ||= dojo_tag_name + (add_multiple_to_name?(opts) ? '[]' : '')
        # @dojo_props[:id] ||= opts.fetch("id") { dojo_tag_id }
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
        when :boolean, :radio
          dtype = 'radio'
        else
          dtype = 'text'
        end
      end
      @dojo_props[:type] = dtype unless dtype.nil? 
    end

    def dojo_tag_name_with_index(index)
      "#{object_name}[#{index}][#{sanitized_attribute_name}]"
    end

    def dojo_tag_id_with_index(index)
      "#{sanitized_object_name}_#{index}_#{sanitized_attribute_name}"
    end

    def add_value_to_dojo_props
      unless [:text, :text_simple].include?(input_type) 
        opts = input_html_options
        @dojo_props[:value] = opts.fetch("value") { value_before_type_cast(object, attribute_name) } unless input_type == "file"
        @dojo_props[:value] &&= html_escape(@dojo_props[:value])
      end
    end

    def value_before_type_cast(object, object_name)
      unless object.nil?
        if self.is_a? Dora::Inputs::CollectionInput
          type = column.try(:type)
          case type
          when :boolean
            object.send(attribute_name.to_s)
          else
            # detect_collection_methods comes from SimpleForm::Inputs::CollectionInput
            label_method, value_method = detect_collection_methods
            object.send(value_method)
          end
        else
          object.respond_to?(attribute_name.to_s + "_before_type_cast") ? 
            object.send(attribute_name.to_s + "_before_type_cast") :
            object.send(attribute_name.to_s)
        end
      end
    end

    def dojo_tag_name
      "#{object_name}[#{sanitized_attribute_name}]"
    end

    def dojo_tag_id
      "#{sanitized_object_name}_#{sanitized_attribute_name}"
    end

    def sanitized_attribute_name
      @sanitized_attribute_name ||= attribute_name.to_s.sub(/\?$/,"")
    end

    def sanitized_object_name
      @sanitized_object_name ||= object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end
  end
end
