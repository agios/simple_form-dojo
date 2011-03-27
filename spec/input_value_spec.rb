require 'spec_helper'

describe "Dora::FormBuilder", :type => :helper do

  context "with type=text" do
    before(:each) do
      @project = Factory(:project)
    end

    it "should have the correct value for a string textbox" do
      @html = with_form_for @project, :name
      @html.should have_tag_selector('form input#project_name')
        .with_dojo_props(:value => @project.name)
    end

    it "should have the correct value for a number textbox" do
      @html = with_form_for @project, :pay_rate
      @html.should have_tag_selector('form input#project_pay_rate')
        .with_dojo_props(:value => @project.pay_rate.to_s)
    end

    it "should have the correct value for a time textbox" do
      @html = with_form_for @project, :start_time
      @html.should have_tag_selector('form input#project_start_time')
        .with_dojo_props(:value => @project.start_time.to_s)
    end

    it "should have the correct value for a password textbox" do
      @html = with_form_for @project, :password
      @html.should have_tag_selector('form input#project_password')
        .with_dojo_props(:value => @project.password)
    end
  end

  context "with TextArea" do
    before(:each) do
      @project = Factory(:project)
    end

    it "should have a SimpleTextArea with a value in the right place" do
      @html = with_form_for @project, :description, :as => :text_simple
      @html.should have_tag_selector('textarea#project_description')
        .with_dojo_type('dijit.form.SimpleTextArea')
        .with_content(@project.description)
    end

    it "should not have a value='' in data-dojo-props for a SimpleTextAreas" do
      @html = with_form_for @project, :description, :as => :text_simple
      @html.should have_tag_selector('textarea#project_description')
        .without_dojo_props(:value => @project.description)
    end
  end

  context "with boolean attribute" do
    before(:each) do
      @task = Factory(:task)
    end

    it "should have a boolean radio set with the correct value" do
      @html = with_form_for @task, :complete, :as => :radio
      @html.should have_tag_selector("input#task_complete_true")
        .with_dojo_props(:value => true)
      @html.should have_tag_selector("input#task_complete_false")
        .with_dojo_props(:value => false)
    end
  end

  context "with associations" do
    before(:each) do
      @project = Factory(:project) 
      @task = Factory(:task)
      Task.stub(:all).and_return([@task])
    end

    it "should have a CheckBox with the correct value" do
      @html = with_association_for @project, :tasks, :as => :check_boxes
      @html.should have_tag_selector("input#project_task_ids_#{@task.id}")
        .with_dojo_props(:value => @task.id)
    end

    it "should have a Radio button with the correct value" do
      @html = with_association_for @project, :tasks, :as => :radio
      @html.should have_tag_selector("input#project_task_ids_#{@task.id}")
        .with_dojo_props(:value => @task.id)
    end

  end
end
