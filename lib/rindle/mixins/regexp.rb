class Rindle
  module Mixins
    module Regexp

      # converts the expressin to a string and
      # strips the special characters for marking
      # the beginning and end of a string
      def strip
        self.source.gsub(/^\^/,'').gsub(/\$$/,'')
      end

    end
  end
end

Regexp.send :include, Rindle::Mixins::Regexp
