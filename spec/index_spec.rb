require "spec_helper"

describe Kindle::Index do
  context '#new' do
    it 'is not empty if there are documents on the kindle'
    it 'derives from Hash' do
      index = Kindle::Index.new(kindle_root)
      index.should be_a(Hash)
    end
  end
end
