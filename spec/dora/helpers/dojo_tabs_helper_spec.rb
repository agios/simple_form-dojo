require 'spec_helper'
    
describe Dora::Helpers::DojoTabsHelper do
  context "creating tabs without a block" do
    it "should raise an error" do
      lambda{ @tabs = dojo_tabs_for }.should raise_error(ArgumentError)
    end
  end
 
  context "creating two tabs" do
    before(:each) do
      @tabs = dojo_tabs_for do |tab|
        tab.create('One') { "Tab One" }
        tab.create('Two') { "Tab Two" }
      end
    end

    it "should create the correct DOM structure" do
      # puts @tabs.inspect
      render :text => @tabs
      assert_select "div[id='tabs']", 1
      assert_select "div[data-dojo-type='dijit.layout.TabContainer']", 1
      assert_select "div[data-dojo-props='doLayout:false']", 1
      assert_select "div[id='tabs'] div[data-dojo-type='dijit.layout.ContentPane']", 2
      assert_select "div[id='tabs'] div[data-dojo-props='title:\'One\'']", 1
      assert_select "div[id='tabs'] div[data-dojo-props='title:\'Two\'']", 1
    end 
  end
 
  context "creating custom tabs" do
    before(:each) do
      @tabs = dojo_tabs_for(:id => "new_tabs") do |tab|
        tab.create('My Tab 1', :id => "tab-one") { 'My content' }
        tab.create('My Tab 2', :id => "tab-two") { 'My content' }
      end 
    end

    it "should allow overriding the ids" do
      # puts @tabs.inspect
      render :text => @tabs
      assert_select "div[id='new_tabs']", 1
      assert_select "div[id='new_tabs'] div[id='tab-one']", 1
      assert_select "div[id='new_tabs'] div[id='tab-two']", 1
    end
  end
end
