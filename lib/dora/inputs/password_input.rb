module Dora
  module Inputs
    class PasswordInput < SimpleForm::Inputs::PasswordInput
      include DojoPropsMethods
      
      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        infer_dojo_props_from_validations!
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        if has_required?
          'dijit/form/ValidationTextBox'
        else
          'dijit/form/TextBox'
        end
      end

      def infer_dojo_props_from_validations!
        @dojo_props ||= {}
        @dojo_props.merge!(:required => true) if has_required?
      end

    end
  end
end
