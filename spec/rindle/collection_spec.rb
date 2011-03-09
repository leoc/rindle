require "spec_helper"

describe Rindle::Collection do
  before(:all) do
    Rindle.load(kindle_root)
  end
  
  context '#all' do
    it 'invokes Collection.find with parameter :all' do
      Rindle::Collection.find(:all).map(&:name).should == Rindle::Collection.all.map(&:name)
    end
  end
  
  context '#find' do
    it 'returns an array of Kindle::Collection objects' do
      Rindle::Collection.find
    end

    context 'filters' do
      it 'by name with string' do
        name = "collection"
        collections = Rindle::Collection.all(:named => name)
        collections.map(&:name).should == ['collection1', 'collection2']
      end
      it 'by name with regular expression' do
        name = /collection[1|3]/
        collections = Rindle::Collection.all(:named => name)
        collections.map(&:name).should == ['collection1']        
      end
      it 'by including one document' do
        pending
        
        collections = Rindle::Collection.all(:including => Rindle::Document.new('#B001UQ5HVA^EBSP'))
        collections.map(&:name).should == ['amazon books']
      end
      it 'by including one of an array of documents'
      it 'by including index' do
        collections = Rindle::Collection.all(:including => '#B001UQ5HVA^EBSP')
        collections.map(&:name).should == ['amazon books']
      end
      it 'by including one of an array of indices' do
        collections = Rindle::Collection.all(:including => [ '*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2', '#B001UQ5HVA^EBSP' ])
        collections.map(&:name).should == ['collection2','amazon books']        
      end
      it 'by last access time' do
        collections = Rindle::Collection.all(:accessed => 1298745909917)
        collections.map(&:name).should == ['amazon books']
      end
    end
  end
  
  context '#files' do
    it 'returns an array of Kindle::Document objects'
  end
  
  context '#to_hash' do
    it 'returns a hash taht could be found in collections.json' do
      now = Time.now.to_i
      collection = Rindle::Collection.new("test", ['a','b','c'], now)
      collection.to_hash.should == { "test@en-US" => { "items" => ['a', 'b', 'c'], "lastAccess" => now } }
    end
  end
end
