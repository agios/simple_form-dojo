module Dora
  module Inputs
    class TimeInput < SimpleForm::Inputs::StringInput

      include DojoPropsMethods

      def input
        input_html_options[:type] = :text
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        'dijit.form.TimeTextBox'
      end

    end
  end
end

