module Dora
  module Common

    ## 
    def get_dojo_props_from_options!
      @dojo_props ||= {}
      @dojo_props.merge!(html_options_for(:dojo, []))
    end

    ## 
    # JSON encodes the props hash, 
    # then translates double-quotes to single-quotes, 
    # then translates double-backslashes to single-backslashes for regex issues, 
    # then removes the surrounding brackets ({...}) from the result 
    def merge_dojo_props!
      input_html_options[:'data-dojo-props'] = ActiveSupport::JSON.encode(@dojo_props)
        .to_s
        .tr('"',"'")
        .sub(/\\\\/, '\\')
        .slice(1..-2) if !@dojo_props.blank?
    end
  end
end
