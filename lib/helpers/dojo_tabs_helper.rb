module DojoTabsHelper
  def dojo_tabs_for( *options, &block )
    raise ArgumentError, "Missing block" unless block_given?
    raw DojoTabsHelper::TabsRenderer.new( *options, &block ).render
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
    end
 
    def render
      content_tag( :div, raw([render_tabs].join), { :id => :tabs, 
                                                    "dojo-data-props" => "doLayout:false", 
                                                    "dojo-data-type" => "dijit.layout.TabContainer" 
                                                  }.merge(@options) )
    end

    private
 
    def render_tabs
      @tabs.collect do |tab| 
        content_tag(:div, capture( &tab[2] ), tab[1].merge( "dojo-data-type" => "dijit.layout.ContentPane", 
                                                            "dojo-data-props" => "title:'#{tab[0]}'"))
      end.join.to_s
    end
 
    def method_missing( *args, &block )
      @template.send( *args, &block )
    end
  end
end
