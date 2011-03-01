require 'action_view'
require 'dora/version'
require 'dora/dojo_tabs_helper'
# require 'helpers/dojo_tabs_helper'

module Dora
end

ActionView::Base.send(:include, Dora::Helpers::DojoTabsHelper)
