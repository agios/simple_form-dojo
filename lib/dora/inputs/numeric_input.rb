module Dora
  module Inputs
    class NumericInput < SimpleForm::Inputs::NumericInput

      include DojoPropsMethods

      def input
        input_html_options[:type] = :text
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        infer_dojo_props_from_validations!
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        'dijit/form/NumberTextBox'
      end

      def integer?
        if input_type == :integer
          @dojo_props ||= {}
          @dojo_props[:constraints] ||= {}
          @dojo_props[:constraints][:places] ||= 0; 
          true
        else
          false
        end
      end

      def infer_dojo_props_from_validations!
        @dojo_props ||= {}
        @dojo_props.merge!(:required => true) if has_required?
        if has_validators?
          # numeric_validator and find_numericality_validator inherited from SimpleForm
          numeric_validator = find_numericality_validator or return
          validator_options = numeric_validator.options
          @dojo_props[:constraints] ||= {}
          @dojo_props[:constraints][:min] ||= minimum_value(validator_options)
          @dojo_props[:constraints][:max] ||= maximum_value(validator_options)
        end
      end
    end
  end
end


