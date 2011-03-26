module Dora
  module Inputs
    # Uses MapType to handle basic input types. See the original simple_form 
    # source for details. 
    class MappingInput < SimpleForm::Inputs::MappingInput
      include DojoPropsMethods
      
      map_type :text_simple, :to => :text_area

      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        infer_dojo_props_from_validations!
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        case input_type
        when :password
          if has_required?
            'dijit.form.ValidationTextBox'
          else
            'dijit.form.TextBox'
          end
        when :text
          'dijit.form.TextArea'
        when :text_simple
          'dijit.form.SimpleTextArea'
        when :file
          raise('File fields have not been implemented yet!')
        end
      end

      def infer_dojo_props_from_validations!
        @dojo_props ||= {}
        @dojo_props.merge!(:required => true) if has_required?
      end
      
    end
  end
end
