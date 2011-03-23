module Dora
  module Common

    def get_dojo_props_from_options!
      @dojo_props.merge!(html_options_for(:dojo, [])) if !@dojo_props.nil?
    end

    def merge_dojo_props!
      input_html_options[:'data-dojo-props'] = @dojo_props.map { |k,v| %Q(#{k}:'#{v}') }.join(',') if !@dojo_props.nil?
    end
  end
end
