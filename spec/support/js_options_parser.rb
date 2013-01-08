module SimpleFormDojo
  class ParseError < ArgumentError
  end

  # Quick and dirty parser, suitable ONLY for parsing dojo props
  # and ONLY in the format supplied by simple_form-dojo
  class JsOptionsParser
    PAREN_PAIRS = {'(' => ')', '{' => '}', '[' => ']', "'" => "'"}
    PAREN_REVERSE = PAREN_PAIRS.invert
    PARENS = PAREN_PAIRS.flatten.uniq!
    KEY_REGEX = /^\s*(\w+)\s*:/

    def self.parse_value(s)
      if s[0] == '{'
        to = find_end(s)

        hash_str = s.slice!(1..to-1)
        s.slice!(0..1)
        parse_hash(hash_str)
      else #string
        if s.to_i.to_s == s.strip
          s.to_i
        elsif s.to_f.to_s == s.strip
          s.to_f
        elsif s.strip == 'true'
          true
        elsif s.strip == 'false'
          false
        else
          s
        end
      end
    end

    def self.parse_key s
      m = s.match(KEY_REGEX)
      if m
        m[1]
      else
        raise ParseError, "Cannot match #{KEY_REGEX} against #{s}"
      end
    end

    def self.parse_hash s
      h = {}
      while s.length>0
        key = parse_key s
        s.sub!(KEY_REGEX, '')
        to = find_end(s, ',')
        h[key] = parse_value(s.slice!(0..to).strip)
        s.slice!(0) if s.length > 0 && s[0] == ','
        s.strip!
      end
      h.symbolize_keys
    end

    def self.parse_array
    end

    def self.find_end s, target = nil, start = 0
      index = start
      paren_stack = []
      while (index < s.length || index == start) && (paren_stack.any? || (target && (s[index] != target)))
        if PARENS.include? s[index]
          if PAREN_PAIRS[paren_stack.last] == s[index] #closed last
            paren_stack.pop
          elsif PAREN_PAIRS.keys.include? s[index] #opening
            paren_stack.push s[index]
          else
            raise ParseError, "Mismatched closing '#{s[index]}' at position #{index}\n\t#{s}\n\t#{'-'*index}^"
          end
        end
        index += 1
      end
      if paren_stack.empty?
        index - 1
      else
        raise ParseError, "Unmatched parens!\n\t#{s}\n\t#{paren_stack.join} still open at end of string"
      end
    end
  end
end
