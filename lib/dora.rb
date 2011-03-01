require 'action_view'
require 'helpers/dojo_tabs_helper'

module Dora
  VERSION = "0.0.1"
end

ActionView::Base.send(:include, DojoTabsHelper)
