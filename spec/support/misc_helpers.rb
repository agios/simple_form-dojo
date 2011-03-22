##
# Miscellaneous helpers 
#
def attr_value(field, element, attr)
  Nokogiri::HTML(field).css(element).first.attr(attr)
end

def with_concat_form_for(object, &block)
  concat helper.dora_form_for(object, &block)
end

def with_form_for(object, *args, &block)
  with_concat_form_for(object) do |f|
    f.input(*args, &block)
  end
end

