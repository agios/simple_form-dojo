require_relative 'js_options_parser'
require 'awesome_print'

module SimpleFormDojo
  module RSpecMatchers
    module ActionView
      def have_dojo_props scope, props
        raise ArgumentError, 'this matcher does not accept block' if block_given?
        DojoPropsMatcher.new(scope, props)
      end

      def with_dojo_props props
        raise StandardError, 'this matcher should be used inside "have_tag" matcher block' unless defined?(@__current_scope_for_nokogiri_matcher)
        raise ArgumentError, 'this matcher does not accept block' if block_given?
        @__current_scope_for_nokogiri_matcher.should have_dojo_props(@__current_scope_for_nokogiri_matcher.instance_variable_get(:@current_scope), props)
      end

      def have_dojo_form text, value=nil, options={}
        options[:with] ||= {}
        with_button text, value, options
      end

      def have_dojo_form action_url, method, options={}, &block
        options[:with] ||= {}
        options[:with].merge!(:'data-dojo-type' => 'dijit/form/Form')
        have_form action_url, method, options, &block
      end

      def with_dojo_button text, value=nil, options={}
        options[:with] ||= {}
        options[:with].merge!(:'data-dojo-type' => 'dijit/form/Button')
        with_button text, value, options
      end

      def with_dojo_text_area name, text=nil, options={}
        if text.is_a?(Hash)
          options.merge!(text)
          text=nil
        end
        options[:with] ||= {}
        options[:with].reverse_merge!({:name => name, :'data-dojo-type' => 'dijit/form/SimpleTextarea'})
        @__current_scope_for_nokogiri_matcher.should have_tag('textarea', options) do
          with_text(/#{Regexp.escape(text)}/) if text
        end
      end

      class DojoPropsMatcher
        def initialize scope, props
          @scope = scope
          @dojo_props = props
          @dojo_props_data = @scope.detect(@scope){|s| s.attribute('data-dojo-props')}.attribute('data-dojo-props')
        end

        def matches? document, &block
          dojo_props_data_present? && dojo_props_exist?
        end

        def failure_message_for_should
          message( "Expected #{expectation}: #{@missing}" )
        end

        def failure_message_for_should_not
          message( "Did not expect #{expectation}" )
        end

        def dojo_props_data_present?
          @missing = "\nNo data-dojo-props tag was found." unless @dojo_props_data.present?
          @dojo_props_data.present?
        end

        def message(msg)
          msg += "\nSubject was #{@scope.to_html}"
        end

        def description
          description = "#{@tag_selector}"
          description += " with dojo type of #{@dojo_type}" if @dojo_type
          description += " with dojo props #{@dojo_props.inspect}" if @dojo_props
        end

        protected
        def dojo_props_exist?
          @dojo_props.nil? || dojo_props_exist(@dojo_props)
        end

        def dojo_props_exist(props)
          tag_props = parse_dojo_props(@dojo_props_data.value)
          missing_msgs = [] 
          if props.all? do |(key,value)|
            # if tag_props.has_key?(key) && tag_props[key].to_s == props[key].to_s
            if tag_props.has_key?(key) && stringify(tag_props[key]) == stringify(value)
              true
            else
              missing_msgs << "\nTag Props: NO KEY for '#{key}'" if !tag_props.has_key?(key)
              missing_msgs << "\nTag Props: #{key} => '#{tag_props[key]}'" if tag_props.has_key?(key)
              missing_msgs << "\nExpected Props: #{key} => '#{value}'"
              false
            end
          end
          true
          else
            @missing = missing_msgs.join(',')
            false
          end
        end

        def stringify(value)
          if value.is_a? Hash
            value.stringify_keys.sort_by{ |k,v| k.to_s }.to_s
          else
            value.to_s
          end
        end

        # converts a sring like 'require:true, sometype:'type', anothertype:function() {}' 
        # to a hash like { :required => "true", :sometype: "'type'", :anothertype => "function() {}"}
        def to_hash(s)
          Hash[*s.scan(/\s*([^:]+)\s*:\s*([^,]+)\s*(?:,)?/).to_a.flatten].symbolize_keys!
        end

        def parse_dojo_props(s)
          JsOptionsParser.parse_hash(s)
        end

        def expectation
          "to have dojo props '#{@dojo_props}'"
        end
      end
    end
  end
end
module RSpec::Matchers
  include SimpleFormDojo::RSpecMatchers::ActionView
end

