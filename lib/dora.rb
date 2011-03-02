require 'action_view'
require_relative 'dora/version'
require_relative 'dora/helpers/dojo_tabs_helper'

module Dora
end

ActionView::Base.send(:include, Dora::Helpers::DojoTabsHelper)
