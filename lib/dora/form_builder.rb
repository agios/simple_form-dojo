module Dora
  class FormBuilder < SimpleForm::FormBuilder
    include Dora::Inputs

    map_type :time,                                 :to => Dora::Inputs::TimeInput
    map_type :radio, :check_boxes,                  :to => Dora::Inputs::CollectionInput
    map_type :integer, :decimal, :float,            :to => Dora::Inputs::NumericInput
    map_type :password, :text, :text_simple, :file, :to => Dora::Inputs::MappingInput
    map_type :string, :email, :search, :tel, :url,  :to => Dora::Inputs::StringInput

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

  end
end
