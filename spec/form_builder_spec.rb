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

  # FORM
  context "with form wrapper" do

    it "should have a form element with a dora_form class" do
      @html = with_form_for Project.new, :name
      @html.should have_tag_selector('form.dora')
    end

    it "should have a form element with the dijit Form type" do
      @html = with_form_for Project.new, :name
      @html.should have_tag_selector('form#new_project.dora')
        .with_dojo_type('dijit.form.Form')
    end

    it "should have a form with an id and a data-dojo-id" do
      args = 
      data = helper.dora_form_for( Project.new, :html => { :id => 'my-test' } ) do |f|
        f.input :name
      end
      html = concat(data)
      html.should have_tag_selector('form#my-test')
        .with_attr('data-dojo-id', 'my-test')
    end
  end

  # VALIDATED TEXT BOX
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

  # REGEXP
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

  # TEXTBOX - no validattion
  context "with optional string attribute" do
    before(:each) do
      @html = with_form_for Project.new, :summary
    end

    it "should generate a regular text box for the dojo type" do
      @html.should have_tag_selector('input#project_summary')
        .with_dojo_type('dijit.form.TextBox')
    end
  end

  # TIME ATTRIBUTE
  context "with time attribute" do
    before(:each) do
      @html = with_form_for Project.new, :start_time
    end

    it "should generate a TimeTextBox" do
      @html.should have_tag_selector('input#project_start_time')
        .with_dojo_type('dijit.form.TimeTextBox')
    end
  end

  # NUMERIC INPUT
  context "with numeric input" do
    context " and constraints " do
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

    context " and constraints based off of validations " do
      it "should generate a NumberTextBox with min/max constraints" do
        @html = with_form_for Project.new, :importance
        @html.should have_tag_selector('input#project_importance')
          .includes_dojo_props(:constraints => {:min => 1, :max => 5, :places => 0 })
      end
      it "should override constraints with dojo_html" do
        @html = with_form_for Project.new, :importance, :dojo_html => { :constraints => { :min => 2, :max => 20 } }
        @html.should have_tag_selector('input#project_importance')
          .includes_dojo_props(:constraints => { :min => 2, :max => 20 })
      end
    end
  end

  # PASSWORDk
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

  # TEXT AREA
  context "with text area input" do
    it "should generate a TextArea with a style attribute" do
      @html = with_form_for Project.new, :description, :input_html => {:style => 'width:300px'}
      @html.should have_tag_selector('textarea#project_description')
        .with_dojo_type('dijit.form.TextArea')
        .with_attr('style', 'width:300px')
    end

    it "should generate a SimpleTextArea with a style attribute" do
      @html = with_form_for Project.new, :description, :as => :text_simple
      @html.should have_tag_selector('textarea#project_description')
        .with_dojo_type('dijit.form.SimpleTextArea')
    end
  end

  # ASSOCIATIONS 
  context "with associations" do
    it "should generate a CheckBox with a type=checkbox attribute" do
      pending
    end

    it "should generatea a RadioButton with a type=radio attribute" do
      pending
    end
  end

  # DORA_FIELDS_FOR
  context "with dora_fields_for" do
    it "should generate a ValidationTextBox" do
      @html = with_fields_for Project.new, :name
      @html.should have_tag_selector('input#project_name')
        .with_dojo_type('dijit.form.ValidationTextBox')
    end

    it "should not generate a surrounding form tag" do
      @hml = with_fields_for Project.new, :name
      @html.should_not have_tag_selector('form')
    end
  end

  # BUTTONS
  context "button" do
    it "should create a button element" do
      @html = with_button_for :post, :submit
      @html.should have_tag_selector("form button.button")
        .with_dojo_type('dijit.form.Button')
        .includes_dojo_props(:type => 'submit')

    end

    it "should create buttons for new records" do
      @html = with_button_for Project.new, :submit
      @html.should have_tag_selector("form button.button")
        .with_dojo_type('dijit.form.Button')
        .includes_dojo_props(:type => 'submit')
    end
  end

  # data-dojo-props[NAME]
  context "name value in data-dojo-props" do
    before(:each) do
      @html = with_form_for Project.new, :name
    end

    it "should have the correct name in data-dojo-props" do
      @html.should have_tag_selector("input#project_name")
        .includes_dojo_props(:name => 'project[name]')
    end
  end
end
