require 'rindle'

def kindle_root; File.join(File.dirname(__FILE__), 'data', 'kindle'); end

# this is to reset the Singleton'ish nature of the Kindle module
class Rindle
  def self.reset
    self.class_variables.each do |var|
      eval "#{var} = nil"
    end
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
