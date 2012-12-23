module Dora
  module Inputs
    class TextInput < SimpleForm::Inputs::TextInput
      include DojoPropsMethods
      
      #map_type :text_simple, :to => :text_area

      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        infer_dojo_props_from_validations!
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        case input_type
        when :text
          'dijit/form/Textarea'
        when :text_simple
          'dijit/form/SimpleTextarea'
        end
      end

      def infer_dojo_props_from_validations!
        @dojo_props ||= {}
        @dojo_props.merge!(:required => true) if has_required?
      end

    end
  end
end
