require 'action_view'
require_relative 'dora/version'
require_relative 'dora/helpers/tabs'

module Dora
end

ActionView::Base.send(:include, Dora::Helpers::TabsHelper)
