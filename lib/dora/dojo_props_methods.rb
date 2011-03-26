module Dora
  module DojoPropsMethods

    ##
    # Retrieves and merges all dojo_props
    def get_and_merge_dojo_props!
      add_dojo_options_to_dojo_props 
      add_default_attributes_to_dojo_props
      merge_dojo_props
    end
   
    ## 
    # JSON encodes the props hash, 
    # then translates double-quotes to single-quotes, 
    # then translates double-backslashes to single-backslashes for regex issues, 
    # then removes the surrounding brackets ({...}) from the result 
    # All required to put this into a string format compatible with data-dojo-* parsing
    def merge_dojo_props
      input_html_options[:'data-dojo-props'] = ActiveSupport::JSON.encode(@dojo_props)
        .to_s
        .tr('"',"'")
        .sub(/\\\\/, '\\')
        .slice(1..-2) if !@dojo_props.blank?
    end

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
    def add_default_attributes_to_dojo_props
      @dojo_props ||= {}
      add_default_name_to_dojo_props 
      add_default_type_to_dojo_props

      # @dojo_props[:value] ||= add_default_value_to_dojo_props
    end

    ##
    # Follows the basic routines as rails does to determine the 
    # name and id of the tag 
    def add_default_name_to_dojo_props
      opts = input_html_options
      if opts.has_key?("index")
        @dojo_props[:name] ||= dojo_tag_name_with_index(opts["index"])
        # @dojo_props[:id] = opts.fetch("id") { dojo_tag_id_with_index(opts["index"]) }
      else
        @dojo_props[:name] ||= dojo_tag_name + (add_multiple_to_name?(opts) ? '[]' : '')
        # @dojo_props[:id] ||= opts.fetch("id") { dojo_tag_id }
      end
    end

    def add_multiple_to_name?(options)
      options.has_key?(:multiple) || 
        input_type == :check_boxes
    end

    ## 
    # Get the dojo input type 
    def add_default_type_to_dojo_props
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

    def add_default_value_to_dojo_props
      raise NotImplementedError
    end

    def dojo_tag_name
      "#{object_name}[#{sanitized_attribute_name}]"
    end

    def dojo_tag_id
      "#{sanitized_object_name}_#{sanitized_attribute_name}"
    end

    def dojo_tag_value
      raise NotImplementedError
    end

    def sanitized_attribute_name
      @sanitized_attribute_name ||= attribute_name.to_s.sub(/\?$/,"")
    end

    def sanitized_object_name
      @sanitized_object_name ||= object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end
  end
end
