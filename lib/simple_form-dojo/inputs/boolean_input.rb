module SimpleFormDojo
  module Inputs
    class BooleanInput < SimpleForm::Inputs::BooleanInput
      include DojoPropsMethods

      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type
        'dijit/form/CheckBox'
      end
    end
  end
end
