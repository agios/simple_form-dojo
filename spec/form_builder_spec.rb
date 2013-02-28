require 'spec_helper'

describe "SimpleFormDojo::FormBuilder", :type => :helper do

  before(:each) do
    # helper.output_buffer = ""
    # helper.stub(:url_for).and_return("")
    # helper.stub(:projects_path).and_return("")
    # helper.stub(:protect_against_forgery?).and_return(false)
    # # let(:project) { Project.new }

    @regex = "'\\d{5}'"

    @dojo_props = {
      :promptMessage => "'This value is required'", 
      :invalidMessage => "'Missing value'", 
      :pattern => @regex, 
      :tooltipPosition => 'right' 
    }
  end

  # FORM
  context "with form wrapper" do
    it "should have a form element with the dijit Form type" do
      @html = with_form_for Project.new, :name
      @html.should have_dojo_form '/projects', :post, with: {id: 'new_project'}
    end

    it "should have a form with an id and a data-dojo-id" do
      data = helper.dojo_form_for( Project.new, :html => { :id => 'my-test' } ) do |f|
        f.input :name
      end
      html = concat(data)
      html.should have_dojo_form '/projects', :post, with: {:id => 'my-test', :'data-dojo-id' => 'my-test'}
    end

    it "should have a form with a remote option" do
      data = helper.dojo_form_for(Project.new, :html => { :id => 'my-test' }, :remote => true ) do |f|
        f.input :name
      end
      html = concat(data)
      html.should have_dojo_form '/projects', :post, with: {:'data-remote' => 'true'}
    end

    it "should have a form with a put method" do
      data = helper.dojo_form_for(Project.new, :method => 'put', :html => { :id => 'my-test' }, :remote => true ) do |f|
        f.input :name
      end
      html = concat(data)
      html.should have_dojo_form '/projects', :post do
        with_hidden_field '_method', 'put'
      end
    end
  end

  # VALIDATED TEXT BOX
  context "with required string attribute" do

    def it_should_have_dojo_props(props)
      @html.should have_tag('input') do
        with_dojo_props(props)
      end
    end

    before(:each) do
      @html = with_form_for Project.new, :name, :dojo_html => @dojo_props
    end

    it "should generate a text field" do
      @html.should have_tag('input.string.required', with: {type: 'text', name: 'project[name]', size: 50})
    end

    it "should generate a ValidationTextBox" do
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/ValidationTextBox'}) do
        with_dojo_props(:required => true)
      end
    end

    it "should generate a ValidationTextBox with a prompt message" do
      it_should_have_dojo_props(:promptMessage => @dojo_props[:promptMessage])
    end

    it "should generate a ValidationTextBox with an invalid message" do
      it_should_have_dojo_props(:invalidMessage => @dojo_props[:invalidMessage])
    end

    it "should generate a ValidationTextBox with a pattern property" do
      it_should_have_dojo_props(:pattern => @regex)
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
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/TextBox'})
    end
  end

  # TIME INPUT
  context "with time attribute" do
    before(:each) do
      @html = with_form_for Project.new, :start_time
    end

    it "should generate a TimeTextBox" do
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/TimeTextBox'})
    end
  end

  # DATE INPUT
  context "with date attribute" do
    it "should generate a DateTextBox" do
      @project = build(:project)
      @html = with_form_for @project, :created_at
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/DateTextBox'})
    end
  end

  # NUMERIC INPUT
  context "with numeric input" do
    context " and constraints " do
      before(:each) do
        @html = with_form_for Project.new, :importance, :dojo_html => {:constraints => {:min => 30, :max => 100}}
      end

      it "should generate a NumberTextBox" do
        @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/NumberTextBox'})
      end

      it "should generate a NumberTextBox with constraints" do
        @html.should have_tag('input') do
          with_dojo_props(:constraints => {:min => 30, :max => 100})
        end
      end
    end

    context " and constraints based off of validations " do
      it "should generate a NumberTextBox with min/max constraints" do
        @html = with_form_for Project.new, :importance
        @html.should have_tag('input') do
          with_dojo_props(:constraints => {:min => 1, :max => 5, :places => 0 })
        end
      end
      it "should override constraints with dojo_html" do
        @html = with_form_for Project.new, :importance, :dojo_html => { :constraints => { :min => 2, :max => 20 } }
        @html.should have_tag('input') do
          with_dojo_props(:constraints => { :min => 2, :max => 20 })
        end
      end
    end
  end

  # CURRENCY INPUT
  context "with currency input" do
    context "and constraints" do
      before(:each) do
        @project = build(:project)
        @html = with_form_for @project, :pay_rate, :as => :currency, :dojo_html => { :constraints => { :min => 1.0, :max => 100.00, :fractional => true } }
      end

      it "should generate a CurrencyTextBox" do
        @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/CurrencyTextBox'})
      end

      it "should generate a CurrencyTextBox with constraints" do
        @html.should have_tag('input') do
          with_dojo_props(:constraints => { :min => 1.0, :max => 100.00, :fractional => true })
        end
      end
    end
  end


  # PASSWORD
  context "with password input" do
    before(:each) do
      @html = with_form_for Project.new, :password
    end

    it "should generate a TextBox with type=password" do
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/TextBox', :type => 'password'})
    end
  end

  # EMAIL
  context "with email input" do
    before(:each) do
      @html = with_form_for Project.new, :email
    end

    it "should generate a TextBox with email regexp and message", :focus => true do
      @emailRe = "'^[\\\\w!#%$*+=?`{|}~^-]+(?:[\\\\w!#%$*+=?`{|}~^.-])*@(?:[a-zA-Z0-9-]+\\\\.)+[a-zA-Z]{2,6}$'"
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/ValidationTextBox'}) do
        with_dojo_props(:invalidMessage => "'Invalid email format.'", :pattern => @emailRe)
      end
    end
  end

  # PHONE
  context "with phone input" do
    before(:each) do
      @html = with_form_for Project.new, :phone
    end
    it "should generate a TextBox with phone regexp and message" do
      @phoneRe = "'^[\\\\d(.)+\\\\s-]+$'"
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/ValidationTextBox'}) do
        with_dojo_props(:invalidMessage => "'Invalid phone format.'", :pattern => @phoneRe)
      end
    end
  end

  # BOOLEAN
  context "with boolean input" do
    before(:each) do
      @task = create(:task)
      @html = with_form_for @task, :complete
    end

    it "should generate a CheckBox", :focus => true do
      @html.should have_tag("input", with: {:'data-dojo-type' => 'dijit/form/CheckBox', :id => "task_#{@task.id}_complete"})
    end
  end

  # TEXT AREA
  context "with text area input" do
    it "should generate a Textarea with a style attribute" do
      @html = with_form_for Project.new, :description, :input_html => {:style => 'width:300px'}
      @html.should have_tag('textarea', with: {:'data-dojo-type' => 'dijit/form/Textarea', :style => 'width:300px'})
    end

    it "should generate a SimpleTextarea with a style attribute" do
      @html = with_form_for Project.new, :description, :as => :text_simple
      @html.should have_tag('textarea', with: {:'data-dojo-type' => 'dijit/form/SimpleTextarea'})
    end
  end

  # ASSOCIATIONS 
  context "with associations" do
    before(:each) do
      @project = create(:project)
      @task = create(:task)
      @department = create(:department)
      Task.stub(:all).and_return([@task, create(:task)])
      Department.stub(:all).and_return([@department, create(:department)])
    end
    it "should generate a CheckBox with a type=checkbox attribute" do
      @html = with_association_for @project, :tasks, :as => :check_boxes
      @html.should have_tag("input#project_#{@project.id}_task_ids_#{@task.id}", 
          with: {:'data-dojo-type' => 'dijit/form/CheckBox', :type => 'checkbox', :name => 'project[task_ids][]'})
    end

    it "should generate a RadioButton with a type=radio attribute" do
      @html = with_association_for @project, :tasks, :as => :radio_buttons
      @html.should have_tag("input#project_#{@project.id}_task_ids_#{@task.id}", 
              with: {:'data-dojo-type' => 'dijit/form/RadioButton', :type => 'radio', :name => 'project[task_ids]'}) 
    end

    it "should generate a FilteringSelect box with all options" do
      @html = with_association_for @project, :department
      @html.should have_tag("select#project_#{@project.id}_department_id", 
              with: {:'data-dojo-type' => 'dijit/form/FilteringSelect', :value => @project.department.id}) do
        Department.all.each{|d| with_option d.name, d.id}
      end
    end

    it "should generate a FilteringSelect box with a QueryReadStore" do
      @html = with_association_for @project, :department, :remote_path => '/departments/qrs'
      @html.should have_tag("select#project_#{@project.id}_department_id", 
              with: {:'data-dojo-type' => 'dijit/form/FilteringSelect', :value => @project.department.id}) do
          with_dojo_props store: "project_#{@project.id}_department_qrs"
      end
      @html.should have_tag("span", with: {:'data-dojo-id' => "project_#{@project.id}_department_qrs", :'data-dojo-type' => 'dojox/data/QueryReadStore'}) do
          with_dojo_props url: "'/departments/qrs'" 
      end
    end

    it "should generate a MultiSelect" do
      @html = with_association_for @project, :tasks
      @html.should have_tag("select#project_#{@project.id}_task_ids", with: {:'data-dojo-type' => 'dijit/form/MultiSelect'})
    end

    it "should generate a MultiSelect box with an option" do
      @html = with_association_for @project, :tasks
      @html.should have_tag(%Q(select#project_#{@project.id}_task_ids > option[value="#{@task.id}"]))
    end

    it "should generate a ComboBox"

  end

  # SIMPLE_FORM_DOJO_FIELDS_FOR
  context "with dojo_fields_for" do
    it "should generate a ValidationTextBox" do
      @html = with_fields_for Project.new, :name
      @html.should have_tag('input', with: {:'data-dojo-type' => 'dijit/form/ValidationTextBox'})
    end

    it "should not generate a surrounding form tag" do
      @html = with_fields_for Project.new, :name
      @html.should_not have_tag('form')
    end
  end

  # BUTTONS
  context "button" do
    it "should create a button element" do
      @html = with_button_for Project.new, :submit, :dojo_html => {:'data-disable-with' => 'Saving...'}
    end

    it "should create buttons for new records" do
      @html = with_button_for Project.new, :submit
      @html.should have_dojo_form '/projects', :post do
        with_dojo_button 'New Project', with: {:type => 'submit', :class => 'button'}
      end
    end
  end
end
