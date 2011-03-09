require "spec_helper"

describe Rindle::Document do
  before(:all) do
    Rindle.load(kindle_root)
  end
  
  after(:all) do
    Rindle.reset
  end
  
  it 'equals another if the index is the same' do
    doc1 = Rindle::Document.new("#B001UQ5HVA^EBSP")
    doc2 = Rindle::Document.new("#B001UQ5HVA^EBSP")
    doc1.should == doc2 
  end
end

