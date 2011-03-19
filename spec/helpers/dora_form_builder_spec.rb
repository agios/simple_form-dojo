require 'spec_helper'

describe 'Dora::FormBuilder Test', :type => :helper do
  def with_form_for(object, *args, &block)
    with_concat_form_for(object) do |f|
    end
  end
end
