require 'spec_helper'

describe "SimpleFormDojo::Helpers::FormHelper Test", :type => :helper do
  before(:each) do
    helper.output_buffer = ""
    helper.stub(:url_for).and_return("")
    helper.stub(:projects_path).and_return("")
    helper.stub(:protect_against_forgery?).and_return(false)
  end

  it "should pass an instance of SimpleFormDojo::FormBuilder to the form_for block" do
    helper.dojo_form_for(Project.new) do |f|
      f.should be_instance_of(SimpleFormDojo::FormBuilder)
    end
  end

end
