module Dora
  # = Dora Dojo Tabs Helper
  module Helpers
    # Provides methods to generate HTML markup for dijit.layout.TabContainer objects 
    #
    # == 
    module DojoTabsHelper
      # Returns an HTML block tag of type DIV with the appropriate dojo-data-type.
      # You must pass a block of tabs as an argument. 
      #
      # ==== Options
      # The +options+ hash is used to pass additional HTML attributes to the parent DIV.
      # 
      # The default dojo-data-props attribute is set to "doLayout:false".
      #
      # The default id attribute is set to "tabs".
      #
      # ==== Examples
      # 
      #   <% dojo_tabs_for do |tab| %>
      #     <% tab.create('Tab Title One') do %>
      #       #... tab contents
      #     <% end %>
      #   <% end %>
      #   # => <div data-dojo-props="doLayout:false" data-dojo-type="dijit.layout.TabContainer" id="tabs">
      #   # =>     <div data-dojo-props="title:'Tab Title One'" data-dojo-type="dijit.layout.ContentPane">
      #   # =>         ... tab contents
      #   # =>     </div>
      #   # => </div>
      def dojo_tabs_for( *options, &block )
        raise ArgumentError, "Missing block" unless block_given?
        raw Dora::Helpers::DojoTabsHelper::TabsRenderer.new( *options, &block ).render
      end   

      class TabsRenderer
        def initialize( options={}, &block )
          raise ArgumentError, "Missing block" unless block_given?
          @template = eval( 'self', block.binding )
          @options = options
          @tabs = []
          yield self
        end

        def create(title, options={}, &block)
          raise "Block needed for TabsRenderer#CREATE" unless block_given?
          @tabs << [ title, options, block ]
          # had to return an empty string. Otherwise, the @tabs object was being 
          # returned when used with the <%= tab.create('title') %> syntax
          return ''
        end
     
        def render
          content_tag( :div, raw([render_tabs].join), { :id => :tabs, 
                                                        "data-dojo-props" => "doLayout:false", 
                                                        "data-dojo-type" => "dijit.layout.TabContainer" 
                                                      }.merge(@options) )
        end

        private
     
        def render_tabs
          @tabs.collect do |tab| 
            content_tag(:div, capture( &tab[2] ), tab[1].merge( "data-dojo-type" => "dijit.layout.ContentPane", 
                                                                "data-dojo-props" => "title:'#{tab[0]}'"))
          end.join.to_s
        end
     
        def method_missing( *args, &block )
          @template.send( *args, &block )
        end
      end
    end
  end
end
