# Dora

Dora helps you sing with [Dojo](http://dojotoolkit.org) and [Rails](http://rubyonrails.org). Or, in more practical terms, she helps you create Dojo Toolkit markup in a Rails 3 environment. 

## Requirements 

Dora currently uses the 1.6rc1 branch of dojo, so it's still highly experimental. 

## DojoTabsHelper

The tabs helper creates markup for dijit.layout.TabContainer. 

    <% dojo_tabs_for do |tab| %>
      <% tab.create('Tab Title One') do %>
        #... tab contents
      <% end %>
      <% tab.create('Tab Title Two') do %>
        #... tab contents
      <% end %>
    <% end %>

**generates...**

    <div data-dojo-props="doLayout:false" data-dojo-type="dijit.layout.TabContainer" id="tabs">
      <div data-dojo-props="title:'Tab Title One'" data-dojo-type="dijit.layout.ContentPane">
        #... tab contents
      </div>
      <div data-dojo-props="title:'Tab Title Two'" data-dojo-type="dijit.layout.ContentPane">
        #... tab contents
      </div>
    </div>

Tabs are rendered in the order you create them. 

Render tabs conditionally by appending a condition to the end of the 'create' block: 

    <% tab.create('Conditional Tab') do %>
      #... tab contents
    <% end unless @current_user.nil? %>

Pass additional HTML options to either the parent DIV or any child tab's: 

    <% dojo_tabs_for(:id => 'my-id', :class => 'new-class', :data-dojo-props => 'doLayout:true') do |tab| %>
      <% tab.create('Tab Title One', :style => 'color: #00f') do %>
        #... tab contents
      <% end %>
    <% end %>
  
The default DOM ID for the parent div is 'id="tabs"' unless you pass an HTML option with a different value.

