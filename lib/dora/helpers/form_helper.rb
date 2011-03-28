module Dora
  module Helpers
    module FormHelper
      
      def dora_form_for(record_or_name_or_array, *args, &block)

        options = args.extract_options!.reverse_merge(:builder => Dora::FormBuilder,
                                                      :html => { :class => 'dora' })

        options[:html][:'data-dojo-id'] ||= options[:html][:id] if options[:html][:id]
        options[:html][:'data-dojo-type'] ||= 'dijit.form.Form'
        # duplicate options in order to apply form_for_options
        # and capture the correct url
        opts = options.dup
        case record_or_name_or_array
        when Array
          object = record_or_name_or_array.last
          apply_form_for_options!(record_or_name_or_array, opts)
        else
          object = record_or_name_or_array
          apply_form_for_options!([object], opts)
        end
        dojo_props = ( opts[:dojo_html] ||= {} )
        dojo_props[:action] ||= url_for(opts[:url] || {})
        dojo_props[:'data-remote'] = true if opts.include?(:remote) && opts[:remote]
        dojo_props[:'accept-charset'] = 'UTF-8'
        dojo_props[:'method'] = opts[:method] ||= 'post' 
        # add dojo-props
        options[:html][:'data-dojo-props'] ||= Dora::FormBuilder.encode_as_dojo_props(dojo_props)

        simple_form_for(record_or_name_or_array, *(args << options), &block).tap do |output|
          form_callbacks.each do |callback|
            output << callback.call
          end
        end
      end

      def dora_fields_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => Dora::FormBuilder)
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
ActionView::Base.send(:include, Dora::Helpers::FormHelper)

