module SimpleFormDojo
  class FormBuilder < SimpleForm::FormBuilder
    include SimpleFormDojo::Inputs
    # need to include this in order to 
    # get the html_escape method
    include ERB::Util

    attr_accessor :dojo_props

    map_type :currency,                             :to => SimpleFormDojo::Inputs::CurrencyInput
    map_type :date, :time, :datetime,               :to => SimpleFormDojo::Inputs::DateTimeInput
    map_type :select, :radio_buttons, :check_boxes, :to => SimpleFormDojo::Inputs::CollectionInput
    map_type :integer, :decimal, :float,            :to => SimpleFormDojo::Inputs::NumericInput
    #map_type :password, :text, :text_simple, :file, :to => SimpleFormDojo::Inputs::MappingInput
    map_type :string, :email, :search, :tel, :url,  :to => SimpleFormDojo::Inputs::StringInput
    map_type :text, :text_simple,                   :to => SimpleFormDojo::Inputs::TextInput
    map_type :password,                             :to => SimpleFormDojo::Inputs::PasswordInput

    # Simple override of initializer in order to add in the dojo_props attribute
    def initialize(object_name, object, template, options, proc)
      @dojo_props = nil
      super(object_name, object, template, options, proc)
    end

    # Creates a button
    # 
    # overrides simple_form's button method
    # 
    # dojo_form_for @user do |f|
    #   f.button :submit, :value => 'Save Me'
    # end
    #
    # To use dojox/form/BusyButton, pass :busy => true
    # dojo_form_for @uswer do |f|
    #   f.button :submit, :busy => true, :value => 'Save Me'
    # end
    #
    # If :value doesn't exist, tries to determine the 
    # the value based on the current object
    def button(type, *args, &block)
      # set options to value if first arg is a Hash
      options = args.extract_options!
      button_type = 'dijit/form/Button'
      button_type = 'dojox/form/BusyButton' if options[:busy]
      options.reverse_merge!(:'data-dojo-type' => button_type) 
      content = ''
      if value = options.delete(:value)
        content = value.html_safe
      else
        content = button_default_value
      end
      dojo_props = { :type => type, :value => content }
      dojo_props.merge!(options[:dojo_html]) if options.include?(:dojo_html)
      options[:'data-dojo-props'] = SimpleFormDojo::FormBuilder.encode_as_dojo_props(dojo_props)
      options[:class] = "button #{options[:class]}".strip
      template.content_tag(:button, content, *(args << options), &block)
    end
   
    # Basically the same as rails submit_default_value
    def button_default_value
      obj = object.respond_to?(:to_model) ? object.to_model : object
      key = obj ? (obj.persisted? ? :edit : :new) : :submit
      model = if obj.class.respond_to?(:model_name)
        obj.class.model_name.human
      else
        object_name.to_s.humanize
      end

      defaults = []
      defaults << "helpers.submit.#{object_name}.#{key}"
      # defaults << "helpers.submit.#{key}"
      defaults << "#{key.to_s.humanize} #{model}"

      I18n.t(defaults.shift, :default => defaults)
    end

    def dojo_collection_radio_buttons(attribute, collection, value_method, 
                              text_method, options={}, html_options={})
      rendered_collection = render_collection(
        collection, value_method, text_method, options, html_options
      ) do |item, value, text, default_html_options|
        local_dojo_props = @dojo_props.dup

        ## Checked?
        #if values_are_equal?(local_dojo_props[:value], value)
          #local_dojo_props[:checked] = "checked"
          #default_html_options[:checked] = "checked"
        #end

        # add in the dojo_props[:value]
        local_dojo_props[:value] = html_escape(value.to_s)
        default_html_options[:'data-dojo-props'] = SimpleFormDojo::FormBuilder.encode_as_dojo_props(local_dojo_props) if !local_dojo_props.nil?
        
        # append the object id to the html id
        default_html_options["id"] = "#{html_options["id"]}_#{value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase}" if html_options["id"].present?

        builder = instantiate_builder(SimpleForm::ActionViewExtensions::RadioButtonBuilder, attribute, item, value, text, default_html_options)
        
        if block_given?
          yield builder
        else
          builder.radio_button + builder.label(:class => "collection_radio_buttons")
        end
      end
      wrap_rendered_collection(rendered_collection, options)
    end

    def dojo_collection_check_boxes(attribute, collection, value_method, 
                                    text_method, options={}, html_options={})
      rendered_collection = render_collection(
        collection, value_method, text_method, options, html_options
      ) do |item, value, text, default_html_options|
        local_dojo_props = @dojo_props.dup

        ## Checked
        #if values_are_equal?(local_dojo_props[:value], value)
          #local_dojo_props[:checked] = "checked"
          #default_html_options[:checked] = "checked"
        #end
        default_html_options[:multiple] = true
        # add in the dojo_props[:value]
        local_dojo_props[:value] = html_escape(value.to_s)
        default_html_options[:'data-dojo-props'] = SimpleFormDojo::FormBuilder.encode_as_dojo_props(local_dojo_props)
        
        # append the object id to the html id
        default_html_options["id"] = "#{html_options["id"]}_#{value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase}" if html_options["id"].present?

        builder = instantiate_builder(SimpleForm::ActionViewExtensions::CheckBoxBuilder, attribute, item, value, text, default_html_options)
        
        if block_given?
          yield builder
        else
          builder.check_box + builder.label(:class => "collection_check_boxes")
        end
      end
      wrap_rendered_collection(rendered_collection, options)
    end

    ## 
    # JSON encodes the props hash, 
    # then translates double-quotes to single-quotes, 
    # then translates double-backslashes to single-backslashes for regex issues, 
    # then removes the surrounding brackets ({...}) from the result 
    # All of this is required in order to place this into a 
    # string format compatible with data-dojo-props parsing
    def self.encode_as_dojo_props(options)
      ActiveSupport::JSON.encode(options)
        .to_s
        .slice(1..-2)
        # .tr('"',"'")
        # .gsub(/\\\\/, '\\')
        # .slice(1..-2)
    end

    private

    def values_are_equal?(obj_value, item_value)
      value = obj_value
      if value.is_a?(String)
        values = obj_value[/\[([,0-9\s]+)\]/,1]
        unless values.nil?
          return values.tr(' ','').split(',').include?(item_value.to_s)
        end
      end
      (value.to_s == item_value.to_s ? true : false)
    end

  end
end
