module Dora
  module Inputs
    class StringInput < SimpleForm::Inputs::StringInput
      def input
        # input_html_options.merge( :class => 'test',  :'data-dojo-type' => 'dijit.form.TextBox' )
        input_html_options[:'data-dojo-type'] = 'dijit.form.TextBox'
        input_html_options[:'data-dojo-props'] = 'required:true'
        super
      end
    end
  end
end
