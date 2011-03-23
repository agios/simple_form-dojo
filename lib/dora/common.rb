module Dora
  module Common

    def get_dojo_props_from_options!
      @dojo_props ||= {}
      @dojo_props.merge!(html_options_for(:dojo, []))
    end

    def merge_dojo_props!
      # input_html_options[:'data-dojo-props'] = @dojo_props.map { |k,v| %Q(#{k}:'#{v}') }.join(',') if !@dojo_props.nil?
      # input_html_options[:'data-dojo-props'] = @dojo_props.to_json.to_s.tr('"',"'") if !@dojo_props.nil?
      puts "DOJO: #{@dojo_props.inspect}"
      input_html_options[:'data-dojo-props'] = ActiveSupport::JSON.encode(@dojo_props).to_s.tr('"',"'") if !@dojo_props.blank?
      puts "IHO: #{ input_html_options[:'data-dojo-props'].inspect }"
    end
  end
end
