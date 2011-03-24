module Dora
  module Common

    def get_dojo_props_from_options!
      @dojo_props ||= {}
      @dojo_props.merge!(html_options_for(:dojo, []))
    end

    def merge_dojo_props!
      input_html_options[:'data-dojo-props'] = ActiveSupport::JSON.encode(@dojo_props)
        .to_s
        .tr('"',"'")
        .sub(/\\\\/, '\\')
        .slice(1..-2) if !@dojo_props.blank?
    end
  end
end
