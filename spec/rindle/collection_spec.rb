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

  context '#first' do
    it 'invokes Collection.find with parameter :first' do
      Rindle::Collection.find(:first).should == Rindle::Collection.first
    end
  end
  
  context '#find' do
    it 'returns an array of Kindle::Collection objects' do
      Rindle::Collection.find
    end

    context 'finds all filtered' do
      it 'by name with string' do
        name = "collection"
        collections = Rindle::Collection.find(:all, :named => name)
        collections.map(&:name).should == ['collection1', 'collection2']
      end

      it 'by name with regular expression' do
        name = /collection[1|3]/
        collections = Rindle::Collection.find(:all, :named => name)
        collections.map(&:name).should == ['collection1']        
      end

      it 'by including index' do
        collections = Rindle::Collection.find(:all, :including => '#B001UQ5HVA^EBSP')
        collections.map(&:name).should == ['amazon books']
      end
      
      it 'by including one of an array of indices' do
        collections = Rindle::Collection.find(:all, :including => [ '*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2', '#B001UQ5HVA^EBSP' ])
        collections.map(&:name).should == ['collection2','amazon books']        
      end

      it 'by last access time' do
        collections = Rindle::Collection.find(:all, :accessed => 1298745909917)
        collections.map(&:name).should == ['amazon books']
      end
    end

    context 'finds first filtered' do
      it 'by name' do
        collection = Rindle::Collection.find(:first, :named => 'collection1')
        collection.name.should == 'collection1'
      end

      it 'by included index' do
        collection = Rindle::Collection.find(:first, :including => '*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2')
        collection.name.should == 'collection2'
      end

      it 'by included index/indices from array' do
        collection = Rindle::Collection.find(:first, :including => [ "*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2", "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7" ])
        ['collection1', 'collection2'].should include(collection.name)
      end

      it 'by last access time' do
        collection = Rindle::Collection.find(:first, :accessed => 1298745909917)
        collection.name.should == 'amazon books'
      end
    end
  end
  
  context '#documents' do
    it 'returns an array of Rindle::Document objects' do
      collection = Rindle::Collection.find(:first, :named => 'collection1')
      collection.documents.each do |document|
        document.should be_a(Rindle::Document)
      end
    end
  end
  
  context '#to_hash' do
    it 'returns a hash taht could be found in collections.json' do
      now = Time.now.to_i
      collection = Rindle::Collection.new("test", ['a','b','c'], now)
      collection.to_hash.should == { "test@en-US" => { "items" => ['a', 'b', 'c'], "lastAccess" => now } }
    end
  end
end
