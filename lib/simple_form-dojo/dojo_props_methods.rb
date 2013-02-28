module SimpleFormDojo
  module DojoPropsMethods
    ##
    # Retrieves and merges all dojo_props
    def get_and_merge_dojo_props!
      add_dojo_options_to_dojo_props 
      if object.id.present?
        add_dojo_compliant_id
      else
        input_html_options["id"] = nil #let dojo generate internal id
      end
      input_html_options[:'data-dojo-props'] = SimpleFormDojo::FormBuilder.encode_as_dojo_props(@dojo_props) if !@dojo_props.blank?
    end

    private 

    ##
    # Retrieves dojo props from :dojo_html => {} options 
    def add_dojo_options_to_dojo_props
      @dojo_props ||= {}
      @dojo_props.merge!(html_options_for(:dojo, []))
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
