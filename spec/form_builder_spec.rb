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

  context "with complex regular expression" do
    before(:each) do 
      @email_regex = '\A[\w!#$%&\'*+/=?`{|}~^-]+(?:\.[\w!#$%&\'*+/=?`{|}~^-]+)*@(?:[A-Z0-9-]+\.)+[A-Z]{2,6}\Z'
      @html = with_form_for Project.new, :name, :dojo_html => { :regExp => @email_regex }
    end

    it "should generate a ValidationTextBox and handle a complicated regExp prop" do
      pending
      @html.should have_tag_selector('input#project_name')
        .includes_dojo_props(:regExp => @email_regex)
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

  context "with numeric input" do
    before(:each) do
      @html = with_form_for Project.new, :pay_rate, :dojo_html => {:constraints => {:min => 30, :max => 100}}
      # @html = with_form_for Project.new, :pay_rate, :dojo_html => @dojo_props
    end

    it "should generate a NumberTextBox" do
      @html.should have_tag_selector('input#project_pay_rate')
        .with_dojo_type('dijit.form.NumberTextBox')
    end

    it "should generate a NumberTextBox with constraints" do
      @html.should have_tag_selector('input#project_pay_rate')
        .includes_dojo_props(:constraints => {:min => 30, :max => 100})
    end
  end

  context "with password input" do
    before(:each) do
      @html = with_form_for Project.new, :password
    end

    it "should generate a TextBox with type=password" do
      @html.should have_tag_selector('input#project_password')
        .with_dojo_type('dijit.form.TextBox')
        .with_attr('type', 'password')
    end
  end
end
