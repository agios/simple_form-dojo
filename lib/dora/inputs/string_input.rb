module Dora
  module Inputs
    class StringInput < SimpleForm::Inputs::StringInput

      include DojoPropsMethods

      def input
        input_html_options[:'data-dojo-type'] ||= dojo_type 
        infer_dojo_props_from_validations!
        get_and_merge_dojo_props!
        super
      end

      protected

      def dojo_type 
        if has_required? || [:tel, :email].include?(input_type)
          'dijit.form.ValidationTextBox'
        else
          'dijit.form.TextBox'
        end
      end

      def infer_dojo_props_from_validations!
        @dojo_props = {}
        @dojo_props.merge!(:required => true) if has_required?
        case input_type
        when :email
          # @dojo_props[:regExp] ||= '^[\w!#%$*+=?`{|}~^-]+(?:[\w!#%$*+=?`{|}~^.-])*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}$'
          @dojo_props[:regExp] ||= "^[\\w!#%$*+=?`{|}~^-]+(?:[\\w!#%$*+=?`{|}~^.-])*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$"
          @dojo_props[:invalidMessage] = 'Invalid email format.'
        when :tel
          @dojo_props[:regExp] ||= "^[\\d(.)+\\s-]+$"
          @dojo_props[:invalidMessage] = 'Invalid phone format.'
        end
      end
      
    end
  end
end
