## 
# Matches selections with data-dojo-type
# @html = with_form_for Project.new, :name
# @html.should have_selection('div#project_name').with_dojo_type('dijit.form.TextBox')
module Dora
  module RSpecMatchers
    module ActionView
      def have_tag_selector(tag_selector)
        TagMatcher.new(tag_selector)
      end

      class TagMatcher #:nodoc:
        def initialize(tag_selector)
          @tag_selector = tag_selector
        end

        def with_dojo_type(type)
          @dojo_type = type
          self
        end

        # Expects a hash in props
        def includes_dojo_props(props)
          @dojo_props = props.symbolize_keys
          self
        end

        def with_attr(name, value)
          @attr_name = name
          @attr_value = value
          self
        end

        def matches?(subject)
          @subject = subject
          tag_selection_exists? &&
            dojo_type_exists? && 
            dojo_props_exist? && 
            attribute_exists?(@attr_name, @attr_value)
        end

        def failure_message
          message = "Expected #{expectation} (#{@missing})"
          message += "\nSubject was: #{@subject}"
        end

        def negative_failure_message
          "Did not expect #{expectation}"
        end

        def description
          description = "#{@tag_selector}"
          description += " with dojo type of #{@dojo_type}" if @dojo_type
          description += " with dojo props #{@dojo_props.inspect}" if @dojo_props
        end

        protected

        def dojo_type_exists?
          # @dojo_type.nil? || @tag_selector_obj['data-dojo-type'].should == @dojo_type
          @dojo_type.nil? || attribute_exists?('data-dojo-type', @dojo_type)
        end

        def dojo_props_exist?
          @dojo_props.nil? || dojo_props_exist
          # @dojo_props.nil? || (dojo_props_exist)
        end

        def dojo_props_exist
          # expected_props = to_hash(@dojo_props) 
          tag_props = to_hash( @tag_selector_obj['data-dojo-props'].to_s )
          @dojo_props.all? do |(key,value)|
            tag_props.has_key?(key) && tag_props[key].to_s == @dojo_props[key].to_s
          end.should == true 
        end
        
        # converts a sring like 'require:true, sometype:"type", "anothertype":"type"' 
        # to a hash like { :required => "true", :sometype: "type", :anothertype => "type"}
        def to_hash(s)
          Hash[*s.scan(/(?:'|")?(\w+)(?:'|")?\s*:\s*(?:'|")?(\w+)(?:'|")?/).to_a.flatten].symbolize_keys!
        end
        
        def attribute_exists?(name, value)
          # @attr_name.nil? || @tag_selector_obj[@attr_name].should == @attr_value
          name.nil? || @tag_selector_obj[name].should == value
        end

        def tag_selection_exists?
          if find_tag_selection.nil?
            @missing = "'#{@tag_selector}' could not be found."
            false
          else
            true
          end
        end
        
        def find_tag_selection
          html = Nokogiri::HTML(@subject)
          @tag_selector_obj = html.at(@tag_selector)
        end

        def expectation
          "Selection to have tag matching '#{@tag_selector}'"
        end
      end
    end
  end
end
module RSpec::Matchers
  include Dora::RSpecMatchers::ActionView
end

