module SimpleFormDojo
  module Inputs
    class DateTimeInput < SimpleForm::Inputs::StringInput

      include DojoPropsMethods

      def input
        input_html_options[:type] = :text
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        case input_type
        when :date, :datetime
          'dijit/form/DateTextBox'
        when :time
          'dijit/form/TimeTextBox'
        end
      end
    end
  end
end

