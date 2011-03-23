module Dora
  module Inputs
    class NumericInput < SimpleForm::Inputs::NumericInput

      include Common 

      def input
        input_html_options[:type] = :text
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        get_dojo_props_from_options!
        merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        'dijit.form.NumberTextBox'
      end

    end
  end
end


