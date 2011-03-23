module Dora
  module Inputs
    class TimeInput < SimpleForm::Inputs::StringInput

      include Common 

      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        get_dojo_props_from_options!
        merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        'dijit.form.TimeTextBox'
      end

    end
  end
end

