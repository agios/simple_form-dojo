require 'spec_helper'

describe "Dora::FormBuilder", :type => :helper do

  before(:each) do
    helper.output_buffer = ""
    helper.stub(:url_for).and_return("")
    helper.stub(:projects_path).and_return("")
    helper.stub(:protect_against_forgery?).and_return(false)
    # let(:project) { Project.new }
    
    @dojo_props = {
      :promptMessage => 'Hey! Listen!', 
      :invalidMessage => 'Invalid error', 
      :regExp => '\d{5}', 
      :tooltipPosition => 'right' 
    }
  end

  context "with required string attribute" do

    def it_should_have_dojo_props(props)
      @html.should have_tag_selector('input#project_name')
        .includes_dojo_props(props)
    end

    before(:each) do
      @html = with_form_for Project.new, :name, :dojo_html => @dojo_props
    end

    it "should generate a text field" do
      # html = with_form_for Project.new, :name
      # html.should have_tag_selector('input#project_name').with_dojo_type('dijit.form.TextBox')
      @html.should have_tag_selector('input#project_name.string.required')
        .with_attr('type', 'text')
        .with_attr('name', 'project[name]')
        .with_attr('size', '50')
    end

    it "should generate a ValidationTextBox" do
      @html.should have_tag_selector('input#project_name')
        .with_dojo_type('dijit.form.ValidationTextBox')
        .includes_dojo_props(:required => true)
    end

    it "should generate a ValidationTextBox with a prompt message" do
      it_should_have_dojo_props(:promptMessage => @dojo_props[:promptMessage])
    end

    it "should generate a ValidationTextBox with an invalid message" do
      it_should_have_dojo_props(:invalidMessage => @dojo_props[:invalidMessage])
    end

    it "should generate a ValidationTextBox with a regExp property" do
      it_should_have_dojo_props(:regExp => @dojo_props[:regExp])
    end

    it "should generate a ValidationTextBox with a tooltip property" do
      it_should_have_dojo_props(:tooltipPosition => @dojo_props[:tooltipPosition])
    end

  end

  context "with optional string attribute" do
    before(:each) do
      @html = with_form_for Project.new, :summary
    end

    it "should generate a regular text box for the dojo type" do
      @html.should have_tag_selector('input#project_summary')
        .with_dojo_type('dijit.form.TextBox')
    end
  end

  context "with time attribute" do
    before(:each) do
      @html = with_form_for Project.new, :start_time
    end

    it "should generate a TimeTextBox" do
      @html.should have_tag_selector('input#project_start_time')
        .with_dojo_type('dijit.form.TimeTextBox')
    end
  end

end
