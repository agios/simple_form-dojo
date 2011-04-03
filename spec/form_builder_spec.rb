require 'spec_helper'

describe "Dora::FormBuilder", :type => :helper do
  
  before(:each) do
    # helper.output_buffer = ""
    # helper.stub(:url_for).and_return("")
    # helper.stub(:projects_path).and_return("")
    # helper.stub(:protect_against_forgery?).and_return(false)
    # # let(:project) { Project.new }

    @regex = '\d{5}'
    
    @dojo_props = {
      :promptMessage => 'This value is required', 
      :invalidMessage => 'Missing value', 
      :regExp => @regex, 
      :tooltipPosition => 'right' 
    }
  end

  # FORM
  context "with form wrapper" do

    it "should have a form element with a dora_form class" do
      @html = with_form_for Project.new, :name
      @html.should have_tag_selector('form')
    end

    it "should have a form element with the dijit Form type" do
      @html = with_form_for Project.new, :name
      @html.should have_tag_selector('form#new_project')
        .with_dojo_type('dijit.form.Form')
    end

    it "should have a form with an id and a data-dojo-id" do
      data = helper.dora_form_for( Project.new, :html => { :id => 'my-test' } ) do |f|
        f.input :name
      end
      html = concat(data)
      html.should have_tag_selector('form#my-test')
        .with_attr('data-dojo-id', 'my-test')
    end

    it "should have a form with the proper action" do
      data = helper.dora_form_for(Project.new, :html => { :id => 'my-test' }, :remote => true ) do |f|
        f.input :name
      end
      html = concat(data)
      html.should have_tag_selector('form#my-test')
        .with_dojo_props(:action => '/projects')
        .with_dojo_props(:'data-remote' => true)
        .with_dojo_props(:'method' => 'post')
    end

    it "should have a form with a put method" do
      data = helper.dora_form_for(Project.new, :method => 'put', :html => { :id => 'my-test' }, :remote => true ) do |f|
        f.input :name
      end
      html = concat(data)
      html.should have_tag_selector('form#my-test')
        .with_dojo_props(:'method' => 'put')
    end
  end

  # VALIDATED TEXT BOX
  context "with required string attribute" do

    def it_should_have_dojo_props(props)
      @html.should have_tag_selector('input#project_name')
        .with_dojo_props(props)
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
        .with_dojo_props(:required => true)
    end

    it "should generate a ValidationTextBox with a prompt message" do
      it_should_have_dojo_props(:promptMessage => @dojo_props[:promptMessage])
    end

    it "should generate a ValidationTextBox with an invalid message" do
      it_should_have_dojo_props(:invalidMessage => @dojo_props[:invalidMessage])
    end

    it "should generate a ValidationTextBox with a regExp property" do
      it_should_have_dojo_props(:regExp => '\\d{5}')
    end

    it "should generate a ValidationTextBox with a tooltip property" do
      it_should_have_dojo_props(:tooltipPosition => @dojo_props[:tooltipPosition])
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

  # TIME INPUT
  context "with time attribute" do
    before(:each) do
      @html = with_form_for Project.new, :start_time
    end

    it "should generate a TimeTextBox" do
      @html.should have_tag_selector('input#project_start_time')
        .with_dojo_type('dijit.form.TimeTextBox')
    end
  end

  # DATE INPUT
  context "with date attribute" do
    it "should generate a DateTextBox" do
      @project = Factory(:project)
      @html = with_form_for @project, :created_at
      @html.should have_tag_selector('input#project_created_at')
        .with_dojo_type('dijit.form.DateTextBox')
    end
  end

  # NUMERIC INPUT
  context "with numeric input" do
    context " and constraints " do
      before(:each) do
        @html = with_form_for Project.new, :importance, :dojo_html => {:constraints => {:min => 30, :max => 100}}
      end

      it "should generate a NumberTextBox" do
        @html.should have_tag_selector('input#project_importance')
          .with_dojo_type('dijit.form.NumberTextBox')
      end

      it "should generate a NumberTextBox with constraints" do
        @html.should have_tag_selector('input#project_importance')
          .with_dojo_props(:constraints => {:min => 30, :max => 100})
      end
    end

    context " and constraints based off of validations " do
      it "should generate a NumberTextBox with min/max constraints" do
        @html = with_form_for Project.new, :importance
        @html.should have_tag_selector('input#project_importance')
          .with_dojo_props(:constraints => {:min => 1, :max => 5, :places => 0 })
      end
      it "should override constraints with dojo_html" do
        @html = with_form_for Project.new, :importance, :dojo_html => { :constraints => { :min => 2, :max => 20 } }
        @html.should have_tag_selector('input#project_importance')
          .with_dojo_props(:constraints => { :min => 2, :max => 20 })
      end
    end
  end

  # CURRENCY INPUT
  context "with currency input" do
    context "and constraints" do
      before(:each) do
        @project = Factory(:project)
        @html = with_form_for @project, :pay_rate, :as => :currency, :dojo_html => { :constraints => { :min => 1.0, :max => 100.00, :fractional => true } }
      end

      it "should generate a CurrencyTextBox" do
        @html.should have_tag_selector('input#project_pay_rate')
          .with_dojo_type('dijit.form.CurrencyTextBox')
      end

      it "should generate a CurrencyTextBox with constraints" do
        @html.should have_tag_selector('input#project_pay_rate')
          .with_dojo_props(:constraints => { :min => 1.0, :max => 100.00, :fractional => true })
      end
    end
  end


  # PASSWORD
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

  # EMAIL
  context "with email input" do
    before(:each) do
      @html = with_form_for Project.new, :email
    end

    it "should generate a TextBox with email regexp and message", :focus => true do
      @emailRe = '^[\\w!#%$*+=?`{|}~^-]+(?:[\\w!#%$*+=?`{|}~^.-])*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$'
      @html.should have_tag_selector('input#project_email')
        .with_dojo_type('dijit.form.ValidationTextBox')
        .with_dojo_props(:invalidMessage => 'Invalid email format.')
        .with_dojo_props(:regExp => @emailRe)
    end
  end


  # PHONE
  context "with phone input" do
    before(:each) do
      @html = with_form_for Project.new, :phone
    end
    it "should generate a TextBox with phone regexp and message" do
      @phoneRe = '^[\\d(.)+\\s-]+$'
      @html.should have_tag_selector('input#project_phone')
        .with_dojo_type('dijit.form.ValidationTextBox')
        .with_dojo_props(:invalidMessage => 'Invalid phone format.')
        .with_dojo_props(:regExp => @phoneRe)
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
    before(:each) do
      @project = Factory(:project)
      @task = Factory(:task)
      @department = Factory(:department)
      Task.stub(:all).and_return([@task, Factory(:task)])
      Department.stub(:all).and_return([@department, Factory(:department)])
    end
    it "should generate a CheckBox with a type=checkbox attribute" do
      @html = with_association_for @project, :tasks, :as => :check_boxes 
      @html.should have_tag_selector("input#project_task_ids_#{@task.id}")
        .with_dojo_type('dijit.form.CheckBox')
        .with_dojo_props(:type => 'checkbox', :name => 'project[task_ids][]')
    end

    it "should generate a RadioButton with a type=radio attribute" do
      @html = with_association_for Project.new, :tasks, :as => :radio 
      @html.should have_tag_selector("input#project_task_ids_#{@task.id}")
        .with_dojo_type('dijit.form.RadioButton')
        .with_dojo_props(:type => 'radio', :name => 'project[task_ids]')
    end

    it "should generate a FilteringSelect box" do
      @html = with_association_for @project, :department
      @html.should have_tag_selector('select#project_department_id')
        .with_dojo_type('dijit.form.FilteringSelect')
        .with_dojo_props(:value => @project.department.id.to_s)
    end

    it "should generate a FilteringSelect box with an option" do
      @html = with_association_for @project, :department
      @html.should have_tag_selector(%Q(select#project_department_id > option[value="#{@department.id}"]))
    end

    it "should generate a MultiSelect" do
      @html = with_association_for @project, :tasks
      @html.should have_tag_selector('select#project_task_ids')
        .with_dojo_type('dijit.form.MultiSelect')
    end

    it "should generate a MultiSelect box with an option" do
      @html = with_association_for @project, :tasks
      @html.should have_tag_selector(%Q(select#project_task_ids > option[value="#{@task.id}"]))
    end

    it "should generate a ComboBox"

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
      @html = with_button_for Project.new, :submit, :dojo_html => {:'data-disable-with' => 'Saving...'}
      @html.should have_tag_selector("form button.button")
        .with_dojo_type('dijit.form.Button')
        .with_dojo_props(:type => 'submit')

    end

    it "should create buttons for new records" do
      @html = with_button_for Project.new, :submit
      @html.should have_tag_selector("form button.button")
        .with_dojo_type('dijit.form.Button')
        .with_dojo_props(:type => 'submit')
    end
  end

  # data-dojo-props[NAME]
  context "name value in data-dojo-props" do
    before(:each) do
      @html = with_form_for Project.new, :name
    end

    it "should have the correct name in data-dojo-props" do
      @html.should have_tag_selector("input#project_name")
        .with_dojo_props(:name => 'project[name]')
    end
  end

  # data-dojo-props[TYPE]
  context "type value in data-dojo-props" do
    it "should have type=text in data-dojo-props" do
      @html = with_form_for User.new, :name
      @html.should have_tag_selector('input#user_name') 
        .with_dojo_props(:type => 'text')
    end

    it "should have type=password in data-dojo-props" do
      @html = with_form_for Project.new, :password
      @html.should have_tag_selector('input#project_password') 
        .with_dojo_props(:type => 'password')
    end
    
    it "should have type=text for time fields in data-dojo-props" do
      @html = with_form_for Project.new, :start_time
      @html.should have_tag_selector('input#project_start_time') 
        .with_dojo_props(:type => 'text')
    end

    it "should have type=text for number fields in data-dojo-props" do
      @html = with_form_for Project.new, :pay_rate
      @html.should have_tag_selector('input#project_pay_rate') 
        .with_dojo_props(:type => 'text')
    end
  end

end
