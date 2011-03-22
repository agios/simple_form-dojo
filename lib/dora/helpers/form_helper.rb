module Dora
  module Helpers
    module FormHelper
      def dora_form_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => Dora::FormBuilder)
        simple_form_for(*(args << options), &block).tap do |output|
          form_callbacks.each do |callback|
            output << callback.call
          end
        end
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
ActionView::Base.send(:include, Dora::Helpers::FormHelper)

