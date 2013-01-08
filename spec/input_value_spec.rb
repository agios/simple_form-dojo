require 'spec_helper'

describe "SimpleFormDojo::FormBuilder", :type => :helper do

  context "with type=text" do
    before(:each) do
      @project = create(:project)
    end

    it "should have the correct value for a string textbox" do
      @html = with_form_for @project, :name
      @html.should have_dojo_form "/projects/#{@project.id}", :post do
        with_tag 'input', with: {name: 'project[name]', type: 'text', id: "project_#{@project.id}_name", value: @project.name}
      end
    end

    it "should have the correct value for a number textbox" do
      @html = with_form_for @project, :pay_rate
      @html.should have_dojo_form "/projects/#{@project.id}", :post do
        with_tag 'input', with: {name: 'project[pay_rate]', type: 'text', id: "project_#{@project.id}_pay_rate", value: @project.pay_rate}
      end
    end

    it "should have the correct value for a time textbox" do
      @html = with_form_for @project, :start_time
      @html.should have_dojo_form "/projects/#{@project.id}", :post do
        with_tag 'input', with: {name: 'project[start_time]', type: 'text', id: "project_#{@project.id}_start_time", value: @project.start_time}
      end
    end

    it "should have the correct value for a password textbox" do
      @html = with_form_for @project, :password
      @html.should have_dojo_form "/projects/#{@project.id}", :post do
        with_tag 'input', with: {name: 'project[password]', type: 'password', id: "project_#{@project.id}_password"}
        without_tag 'input', with: {value: @project.password}
      end
    end
  end

  context "with Textarea" do
    before(:each) do
      @project = create(:project)
    end

    it "should have a SimpleTextarea with a value in the right place" do
      @html = with_form_for @project, :description, :as => :text_simple
      @html.should have_dojo_form "/projects/#{@project.id}", :post do
        with_dojo_text_area 'project[description]', @project.description, with: {id: "project_#{@project.id}_description"}
      end
    end
  end

  context "with boolean attribute" do
    before(:each) do
      @task = build(:task)
    end

    it "should have a boolean radio set with the correct value" do
      @html = with_form_for @task, :complete, :as => :radio_buttons
      @html.should have_dojo_form "/tasks", :post do
        with_radio_button 'task[complete]', true
        with_radio_button 'task[complete]', false
      end
    end
  end

  context "with associations" do
    before(:each) do
      @project = create(:project) 
      @task = create(:task)
      Task.stub(:all).and_return([@task])
    end

    it "should have a CheckBox with the correct value" do
      @html = with_association_for @project, :tasks, :as => :check_boxes
      @html.should have_tag 'input', with: {id: "project_#{@project.id}_task_ids_#{@task.id}", :value => @task.id}
    end

    it "should have a Radio button with the correct value" do
      @html = with_association_for @project, :tasks, :as => :radio_buttons
      @html.should have_tag 'input', with: {id: "project_#{@project.id}_task_ids_#{@task.id}", :value => @task.id}
    end

  end
end
