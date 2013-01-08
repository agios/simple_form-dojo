module SimpleFormDojo
  module Helpers
    module FormHelper
      
      def dojo_form_for(record_or_name_or_array, *args, &block)
        options = args.extract_options!.reverse_merge(:builder => SimpleFormDojo::FormBuilder)
        options[:html] ||= {}
        options[:html][:'data-dojo-id'] ||= options[:html][:id] if options[:html][:id]
        options[:html][:'data-dojo-type'] ||= 'dijit/form/Form'
        simple_form_for(record_or_name_or_array, *(args << options), &block).tap do |output|
          form_callbacks.each do |callback|
            output << callback.call
          end
        end
      end

      def dojo_fields_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => SimpleFormDojo::FormBuilder)
        simple_fields_for(*(args << options), &block)
      end

      def form_associations
        @form_associations ||= []
      end

      def form_callbacks
        @form_callbacks ||= []
      end
    end
  end
end
ActionView::Base.send(:include, SimpleFormDojo::Helpers::FormHelper)
