require 'spec_helper'

describe Kindle do
  before(:each) do
    Kindle.reset
  end
  
  context '.collections' do
    it 'raises a NotLoaded error if not loaded' do
      lambda { Kindle::collections }.should raise_error(Kindle::NotLoaded)
    end
    it 'returns an instance of Kindle::Collections if module loaded' do
      Kindle::load(kindle_root)
      Kindle::collections.should be_a(Kindle::Collections)
    end
  end

  context '.index' do
    it 'raises a NotLoaded error if not loaded' do
      lambda { Kindle::index }.should raise_error(Kindle::NotLoaded)
    end
    it 'returns an instance of Kindle::Index if module loaded' do
      Kindle::load(kindle_root)
      Kindle::index.should be_a(Kindle::Index)
    end
  end
  
  context '.root_path' do
    it 'provieds a string if loaded' do
      Kindle::load(kindle_root)
      Kindle::root_path.should be_a(String)
    end
    it 'raises a NotLoaded error if not loaded' do
      lambda { Kindle::root_path }.should raise_error(Kindle::NotLoaded)
    end
  end
end
