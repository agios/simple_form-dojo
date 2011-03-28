module Dora
  class FormBuilder < SimpleForm::FormBuilder
    include Dora::Inputs

    attr_accessor :dojo_props

    map_type :currency,                             :to => Dora::Inputs::CurrencyInput
    map_type :date, :time, :datetime,               :to => Dora::Inputs::DateTimeInput
    map_type :select, :radio, :check_boxes,         :to => Dora::Inputs::CollectionInput
    map_type :integer, :decimal, :float,            :to => Dora::Inputs::NumericInput
    map_type :password, :text, :text_simple, :file, :to => Dora::Inputs::MappingInput
    map_type :string, :email, :search, :tel, :url,  :to => Dora::Inputs::StringInput

    # Simple override of initializer in order to add in the dojo_props attribute
    def initialize(object_name, object, template, options, proc)
      @dojo_props = nil
      super(object_name, object, template, options, proc)
    end

    # Creates a button
    # 
    # overrides simple_form's button method
    # 
    # dora_form_for @user do |f|
    #   f.button :submit, :value => 'Save Me'
    # end
    #
    # If :value doesn't exist, tries to determine the 
    # the value based on the current object
    def button(type, *args, &block)
      # set options to value if first arg is a Hash
      options = args.extract_options!.reverse_merge(:'data-dojo-type' => 'dijit.form.Button', 
                                                    :'data-dojo-props' => "type:'#{type}'")
      options[:class] = "button #{options[:class]}".strip
      content = ''
      if value = options.delete('value')
        content = value.html_safe
      else
        content = button_default_value
      end
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

    def dojo_collection_radio(attribute, collection, value_method, 
                              text_method, options={}, html_options={})
      render_collection(
        attribute, collection, value_method, text_method, options, html_options
      ) do |value, text, default_html_options|
        # add in the dojo_props[:value]
        @dojo_props[:value] = value.to_s
        default_html_options[:'data-dojo-props'] = encode_as_dojo_props(@dojo_props) if !@dojo_props.nil?
        radio = radio_button(attribute, value, default_html_options)
        collection_label(attribute, value, radio, text, :class => 'collection_radio')
      end
    end

    def dojo_collection_check_boxes(attribute, collection, value_method, 
                                    text_method, options={}, html_options={})
      render_collection(
        attribute, collection, value_method, text_method, options, html_options
      ) do |value, text, default_html_options|
        default_html_options[:multiple] = true
        # add in the dojo_props[:value]
        @dojo_props[:value] = value.to_s
        default_html_options[:'data-dojo-props'] = encode_as_dojo_props(@dojo_props) if !@dojo_props.nil?
        check_box = check_box(attribute, default_html_options, value, '')
        collection_label(attribute, value, check_box, text, :class => 'collection_check_boxes')
      end
    end

    ## 
    # JSON encodes the props hash, 
    # then translates double-quotes to single-quotes, 
    # then translates double-backslashes to single-backslashes for regex issues, 
    # then removes the surrounding brackets ({...}) from the result 
    # All of this is required in order to place this into a 
    # string format compatible with data-dojo-props parsing
    def encode_as_dojo_props(options)
      ActiveSupport::JSON.encode(options)
        .to_s
        .tr('"',"'")
        .sub(/\\\\/, '\\')
        .slice(1..-2)
    end

  end
end
