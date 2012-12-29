##
# Miscellaneous helpers 
#
def attr_value(field, element, attr)
  Nokogiri::HTML(field).css(element).first.attr(attr)
end

def with_concat_args_form_for(object, *args, &block)
  concat helper.dojo_form_for(object, *args, &block)
end

def with_concat_form_for(object, &block)
  concat helper.dojo_form_for(object, &block)
end

def with_concat_fields_for(object, &block)
  concat helper.dojo_fields_for(object, &block)
end

def with_args_form_for(object, *args, &block)
  with_concat_args_form_for(object, *args) do |f|
    f.input(*args, &block)
  end
end

def with_form_for(object, *args, &block)
  with_concat_form_for(object) do |f|
    f.input(*args, &block)
  end
end

def with_fields_for(object, *args, &block)
  with_concat_fields_for(object) do |f|
    f.input(*args, &block)
  end
end

def with_button_for(object, *args)
  with_concat_form_for(object) do |f|
    f.button(*args)
  end
end

def with_association_for(object, *args)
  with_concat_form_for(object) do |f|
    f.association(*args)
  end
end

