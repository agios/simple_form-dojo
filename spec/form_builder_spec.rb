require 'spec_helper'

describe "Dora::FormBuilder", :type => :helper do

  before(:each) do
    helper.output_buffer = ""
    helper.stub(:url_for).and_return("")
    helper.stub(:projects_path).and_return("")
    helper.stub(:protect_against_forgery?).and_return(false)
    # let(:project) { Project.new }
  end

  context "text" do

    # it "contains an attribute named type" do
    #   helper.dora_form_for(Project.new) do |f|
    #     # Nokogiri::HTML(f.input(:name)).css("input").first.attr("type").should == "text"
    #     attr_value(f.input(:name),"input","type").should == "text"
    #   end
    # end

    # it "should generate text fields for string columns" do
    #   with_form_for Project.new, :name
    #   # assert_select 'form input#project_name.string'
    #   assert_select 'form input#project_name.string[type=?]', 'text'
    #   # assert_select 'form input#project_name.string[dojo-data-type=?]', 'dijit.form.TextBox'
    #   # assert_select 'form input[data-dojo-type=?]', 'dijit.form.TextBox'
    # end

    before(:each) do
      @html = with_form_for Project.new, :name
    end

    it "should generate a text field" do
      # html = with_form_for Project.new, :name
      # html.should have_tag_selector('input#project_name').with_dojo_type('dijit.form.TextBox')
      @html.should have_tag_selector('input#project_name.string.optional')
        .with_attr('type', 'text')
        .with_attr('name', 'project[name]')
        .with_attr('size', '50')
    end

    it "should generate a text field with the right dojo type" do
      @html.should have_tag_selector('input#project_name')
        .with_dojo_type('dijit.form.TextBox')
        # .includes_dojo_props(:required => true)
    end

  end

end
