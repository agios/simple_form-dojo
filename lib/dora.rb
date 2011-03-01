require 'action_view'
require 'dora/version'
require 'helpers/dojo_tabs_helper'

module Dora
end

ActionView::Base.send(:include, DojoTabsHelper)
