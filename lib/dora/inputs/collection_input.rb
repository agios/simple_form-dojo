module Dora
  module Inputs
    class CollectionInput < SimpleForm::Inputs::CollectionInput

      include Common

      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        infer_dojo_props_from_validations!
        get_dojo_props_from_options!
        merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        case input_type
        when :check_boxes
          'dijit.form.CheckBox'
        when :radio
          'dijit.form.RadioButton'
        end
      end

      def infer_dojo_props_from_validations!
      end

    end
  end
end
