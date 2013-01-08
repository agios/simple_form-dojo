module SimpleFormDojo
  module Inputs
    class CollectionInput < SimpleForm::Inputs::CollectionInput

      include DojoPropsMethods

      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        infer_dojo_props_from_validations!
        get_and_merge_dojo_props!

        label_method, value_method = detect_collection_methods
        collection_method = @builder.respond_to?(:"dojo_collection_#{input_type}") ? 
          "dojo_collection_#{input_type}" : 
          "collection_#{input_type}"
        @builder.dojo_props = @dojo_props
        @builder.send(collection_method, attribute_name, collection, value_method, 
                      label_method, input_options, input_html_options)
      end

      protected

      def dojo_type 
        case input_type
        when :check_boxes
          'dijit/form/CheckBox'
        when :radio_buttons
          'dijit/form/RadioButton'
        when :select
          (input_html_options.has_key?(:multiple) ? 'dijit/form/MultiSelect' : 'dijit/form/FilteringSelect')
        end
      end

      def infer_dojo_props_from_validations!
        @dojo_props ||= {}
        @dojo_props.merge!(:required => has_required?)
      end

    end
  end
end
