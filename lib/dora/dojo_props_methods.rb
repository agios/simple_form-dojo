module Dora
  module DojoPropsMethods

    ##
    # Retrieves and merges all dojo_props
    def get_and_merge_dojo_props!
      get_dojo_props_from_options
      merge_dojo_props!
    end
   
    ##
    # Retrieves dojo props from :dojo_html => {} options 
    def get_dojo_props_from_options
      @dojo_props ||= {}
      @dojo_props.merge!(html_options_for(:dojo, []))
    end

    ##
    # Using data-dojo-props with Dojo 1.6.0+ 
    # requires adding attributes such as name, value, class, etc. 
    # into the data-dojo-props attribute in order for them to be 
    # properly parsed by dojo when reading the attribute line
    # See: http://bugs.dojotoolkit.org/ticket/11490
    def add_default_attributes_to_dojo_props!
      @dojo_props ||= {}
      @dojo_props[:name] ||= add_ 
      @dojo_props[:value] ||= default_tag_value
    end

    ## 
    # JSON encodes the props hash, 
    # then translates double-quotes to single-quotes, 
    # then translates double-backslashes to single-backslashes for regex issues, 
    # then removes the surrounding brackets ({...}) from the result 
    # All required to put this into a string format compatible with data-dojo-* parsing
    def merge_dojo_props!
      input_html_options[:'data-dojo-props'] = ActiveSupport::JSON.encode(@dojo_props)
        .to_s
        .tr('"',"'")
        .sub(/\\\\/, '\\')
        .slice(1..-2) if !@dojo_props.blank?
    end

    def default_tag_name
      "#{object_name}[#{sanitized_attribute_name}]"
    end

    def default_tag_value

    end

    def sanitized_attribute_name
      @sanitized_attribute_name ||= @attribute_name.sub(/\?$/,"")
    end
  end
end
