# -*- coding: utf-8 -*-
require "spec_helper"

describe Rindle::Collection do
  before(:all) do
    Rindle.load(kindle_root)
  end

  describe '.exists?' do
    it 'returns true if the collection exists' do
      Rindle::Collection.exists?(:named => 'collection1').should == true
    end

    it 'returns false if the collection does not exist' do
      Rindle::Collection.exists?(:named => 'collection5').should == false
    end
  end

  describe '.all' do
    it 'invokes Collection.find with parameter :all' do
      Rindle::Collection.find(:all).map(&:name).should == Rindle::Collection.all.map(&:name)
    end
  end

  describe '.first' do
    it 'invokes Collection.find with parameter :first' do
      Rindle::Collection.find(:first).should == Rindle::Collection.first
    end
  end

  describe '.find_by_name' do
    it 'should return the collection by name' do
      Rindle::Collection.find_by_name('collection1').
        name.should == 'collection1'
    end

    it 'should return nil if not found' do
      Rindle::Collection.find_by_name('collection3').
        should == nil
    end
  end

  describe '.create' do
    before :all do
      @col = Rindle::Collection.create 'some_collection'
    end

    after :all do
      Rindle.collections.delete 'some_collection'
    end

    it 'should create a new collection object' do
      @col.should_not == nil
    end

    it 'should add the collection to collections hash' do
      Rindle.collections['some_collection'] == @col
    end
  end

  describe '.find' do
    it 'returns an array of Kindle::Collection objects' do
      Rindle::Collection.find
    end

    describe 'finds all filtered' do
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

      it 'by including all of an array of indices' do
        collections = Rindle::Collection.find(:all, :including => ["*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", "*0849dd9b85fc341d10104f56985e423b3848e1f3"])
        collections.map(&:name).should == ['collection1']
      end

      it 'by last access time' do
        collections = Rindle::Collection.find(:all, :accessed => 1298745909917)
        collections.map(&:name).should == ['amazon books']
      end
    end

    describe 'finds first filtered' do
      it 'by name' do
        collection = Rindle::Collection.find(:first, :named => 'collection1')
        collection.name.should == 'collection1'
      end

      it 'by included index' do
        collection = Rindle::Collection.find(:first, :including => '*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2')
        collection.name.should == 'collection2'
      end

      it 'by last access time' do
        collection = Rindle::Collection.find(:first, :accessed => 1298745909917)
        collection.name.should == 'amazon books'
      end
    end
  end

  describe 'Instance' do
    before :all do
      @col = Rindle::Collection.create 'test collection'
      @col.add "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7"
      @col.add '#B001UQ5HVA^EBSP'
    end

    after :all do
      Rindle.collections.delete 'test collection'
    end

    describe '#documents' do
      it 'returns an array of Rindle::Document objects' do
        @col.documents.each do |document|
          document.should be_a(Rindle::Document)
        end
      end
    end

    describe '#documents=' do
      it 'should set the documents indices to be the new indices array' do
        docs = [ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", '#B001UQ5HVA^EBSP' ].map do |index|
          Rindle::Document.find_by_index index
        end
        @col.documents = docs
        @col.indices.should == [ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", '#B001UQ5HVA^EBSP' ]
      end
    end

    describe '#include?' do
      context 'given an Array' do
        it 'should return true if all indices are included' do
          @col.include?([ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", '#B001UQ5HVA^EBSP' ]).should == true
        end
        it 'should return false if one is not included' do
          @col.include?([ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", '#B001UQ5HVB^EBSP' ]).should == false
        end
        it 'should return false if none is included' do
          @col.include?([ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b6", '#B001UQ5HVB^EBSP' ]).should == false
        end
      end

      context 'given a document' do
        it 'should return true if the documents index is included' do
          doc = Rindle::Document.find_by_name 'A test aswell.mobi'
          @col.include?(doc).should == true
        end
        it 'should return false if the documents index isn´t included' do
          doc = Rindle::Document.find_by_name 'Definitely a Test.pdf'
          @col.include?(doc).should == false
        end
      end

      context 'given an index' do
        it 'should return true if index is included' do
          @col.include?("*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7").should == true
        end

        it 'should return false if index isn´t included' do
          @col.include?("*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b6").should == false
        end
      end
    end

    describe '#indices=' do
      before :all do
        @col.indices = [ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7" ]
      end

      after :all do
        @col.indices = [ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", "#B001UQ5HVB^EBSP" ]
      end

      it 'should set the indices array' do
        @col.indices.should == [ "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7" ]
      end
      it 'should clear the memoized documents array' do
        @col.documents.should == [ Rindle::Document.find_by_index("*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7") ]
      end
    end

    describe '#rename!' do
      before :all do
        @col.rename! 'renamed test collection'
      end

      after :all do
        @col.rename! 'test collection'
      end

      it 'should remove the old collections entry' do
        Rindle.collections.should_not have_key 'test collection'
      end

      it 'should add the new collections entry' do
        Rindle.collections.should have_key 'renamed test collection'
      end

      it 'should change the collections name' do
        @col.name.should == 'renamed test collection'
      end
    end

    describe '#destroy!' do
      before :all do
        @col.destroy!
      end

      after :all do
        @col = Rindle::Collection.create 'test collection'
        @col.add "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7"
        @col.add "#B001UQ5HVA^EBSP"
      end

      it 'should remove the collections entry' do
        Rindle.collections.should_not have_key 'test collection'
      end
    end

    describe '#add' do
      context 'given a document' do
        before :all do
          @col.add Rindle::Document.find_by_name 'Definitely a Test.pdf'
        end

        after :all do
          @col.remove "*0849dd9b85fc341d10104f56985e423b3848e1f3"
        end

        it 'should add the documents index' do
          @col.indices.should =~ ["*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7",
                                  "#B001UQ5HVB^EBSP",
                                  "*0849dd9b85fc341d10104f56985e423b3848e1f3"]
        end
      end

      context 'given an index' do
        before :all do
          @col.add "*0849dd9b85fc341d10104f56985e423b3848e1f3"
        end

        after :all do
          @col.remove "*0849dd9b85fc341d10104f56985e423b3848e1f3"
        end

        it 'should add the index' do
          @col.indices.should include "*0849dd9b85fc341d10104f56985e423b3848e1f3"
        end
      end
    end

    describe '#remove' do
      context 'given a document' do
        before :all do
          @col.remove Rindle::Document.find_by_name 'A test aswell.mobi'
        end

        after :all do
          @col.add "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7"
        end

        it 'should remove the documents index' do
          @col.indices.should_not include '*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7'
        end
      end

      context 'given an index' do
        before :all do
          @col.remove "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7"
        end

        after :all do
          @col.add "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7"
        end

        it 'should remove the index' do
          @col.indices.should_not include '*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7'
        end
      end
    end

    describe '#to_hash' do
      it 'returns a hash that could be found in collections.json' do
        now = Time.now.to_i
        collection = Rindle::Collection.new("test",
                                            :indices => ['a','b','c'],
                                            :last_access => now)
        collection.to_hash.should == { "test@en-US" => { "items" => ['a', 'b', 'c'], "lastAccess" => now } }
      end
    end
  end
end
