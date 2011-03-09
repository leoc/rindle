require 'spec_helper'

describe Rindle do
  before(:each) do
    Rindle.reset
  end
  
  context '.collections' do
    it 'raises a NotLoaded error if not loaded' do
      lambda { Rindle::collections }.should raise_error(Rindle::NotLoaded)
    end
    it 'returns an instance of Kindle::Collections if module loaded' do
      Rindle::load(kindle_root)
      Rindle::collections.should be_a(Rindle::Collections)
    end
  end

  context '.index' do
    it 'raises a NotLoaded error if not loaded' do
      lambda { Rindle::index }.should raise_error(Rindle::NotLoaded)
    end
    it 'returns an instance of Kindle::Index if module loaded' do
      Rindle::load(kindle_root)
      Rindle::index.should be_a(Rindle::Index)
    end
  end
  
  context '.root_path' do
    it 'provieds a string if loaded' do
      Rindle::load(kindle_root)
      Rindle::root_path.should be_a(String)
    end
    it 'raises a NotLoaded error if not loaded' do
      lambda { Rindle::root_path }.should raise_error(Rindle::NotLoaded)
    end
  end
end
