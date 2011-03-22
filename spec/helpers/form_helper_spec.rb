require 'spec_helper'

describe "Dora::Helpers::FormHelper Test", :type => :helper do
  before(:each) do
    helper.output_buffer = ""
    helper.stub(:url_for).and_return("")
    helper.stub(:projects_path).and_return("")
    helper.stub(:protect_against_forgery?).and_return(false)
  end

  it "should pass an instance of Dora::FormBuilder to the form_for block" do
    helper.dora_form_for(Project.new) do |f|
      f.should be_instance_of(Dora::FormBuilder)
    end
  end

end
