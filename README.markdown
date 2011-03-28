# Dora

Dora is a collection of helpers for use with [Dojo](http://dojotoolkit.org) and [Rails](http://rubyonrails.org). The goal of the project is to make it simple to create Dijit elements using the existing Rails helper infrastructure.  

The FormBuilder is currently an extension to the [SimpleForm project](https://github.com/plataformatec/simple_form) from [Plataforma](http://blog.plataformatec.com.br/tag/simple_form). 

The TabsHelper was inspired by code from CodeOfficer's [JQuery UI Helpers](https://github.com/CodeOfficer/jquery-ui-rails-helpers)

## Requirements 

Dora is based on Dojo 1.6.0 and uses the newer data-dojo-type and data-dojo-props attributes in order to be more compliant with HTML 5. It is being developed against the latest version of Rails (currently 3.0.5). 

I don't include the 1.6 dojo toolkit files in the git repository. So, to run the dummy test rails environment you'll need to [grab a copy](http://download.dojotoolkit.org/) of the toolkit files and place them in the spec/dummy/public/javascripts/ directory to run the physical rails tests and see the generated markup correctly.

## Dora::FormBuilder 

* Documentation is TBD, but in general, it works the same way that simple_form works: 

    <%= dora_form_for(@user, :html => { :id => 'userForm' } ) do |f| %>
    <%= f.error_messages %>
    <%= f.input :username %>
    <%= f.input :name %>
    <%= f.input :email %>
    <%= f.input :pay_rate, :as => :currency, 
                :dojo_html => { :promptMessage => 'Invalid Amount' 
                                :currency => 'USD' }%>
    <%= f.association :roles, :as => :check_boxes %>
    <%= f.association :departments, :multiple => true %>
    <%= f.input :created_at %>
    <%= f.input :activated, :label => 'Active?', :as => :radio
    <% end %>

* Dijit currently included in Dora::FormBuilder
** dijit.form.CurrencyTextBox
** dijit.form.DateTextBox
** dijit.form.NumberTextBox
** dijit.form.SimpleTextArea
** dijit.form.TextArea
** dijit.form.TextBox
** dijit.form.ValidationTextBox
** dijit.form.MultiSelect (using option tags only - stores not implemented yet)
** dijit.form.FilteringSelect (using options tags only - stores not implemented yet) 
** dijit.form.Button
** dijit.form.CheckBox
** dijit.form.Form
** dijit.form.RadioButton

## Dora::Helpers::TabsHelper 

The tabs helper creates markup for dijit.layout.TabContainer. 

    <%= dora_tabs_for do |tab| %>
      <%= tab.create('Tab Title One') do %>
        #... tab contents
      <% end %>
      <%= tab.create('Tab Title Two') do %>
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

    <%= tab.create('Conditional Tab') do %>
      #... tab contents
    <% end unless @current_user.nil? %>

Pass additional HTML options to either the parent DIV or any child tab's: 

    <%= dora_tabs_for(:id => 'my-id', :class => 'new-class', :data-dojo-props => 'doLayout:true') do |tab| %>
      <%= tab.create('Tab Title One', :style => 'color: #00f') do %>
        #... tab contents
      <% end %>
    <% end %>
  
The default DOM ID for the parent div is 'id="tabs"' unless you pass an HTML option with a different value.

