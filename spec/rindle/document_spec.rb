require "spec_helper"

describe Rindle::Document do
  before(:all) do
    Rindle.load(kindle_root)
  end

  after(:all) do
    Rindle.reset
  end

  it 'equals another document if the index is the same' do
    doc1 = Rindle::Document.new('documents/ABC-asin_B001UQ5HVA-type_EBSP-v1.azw')
    doc2 = Rindle::Document.new('documents/ABC-asin_B001UQ5HVA-type_EBSP-v1.azw')
    doc1.should == doc2
  end

  describe '.find' do
    context 'finds :all filtered' do
      it 'by name with string' do
        docs = Rindle::Document.find(:all, :named => 'A test aswell.mobi')
        docs.map(&:filename).should == ['A test aswell.mobi']
      end

      it 'by name with regular expression' do
        docs = Rindle::Document.find(:all, :named => /t([es]+)t/)
        docs.map(&:filename).should == ['A test aswell.mobi',
                                        'This is a test document.rtf']
      end

      it 'by index' do
        docs = Rindle::Document.find(:all, :indexed => '*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7')
        docs.map(&:filename).should == ['A test aswell.mobi']
      end
    end

    context 'finds :first filtered' do
      it 'by name with string' do
        doc = Rindle::Document.find(:first, :named => 'A test aswell.mobi')
        doc.filename.should == 'A test aswell.mobi'
      end

      it 'by name with regular expression' do
        doc = Rindle::Document.find(:first, :named => /t([es]+)t/)
        doc.filename.should == 'A test aswell.mobi'
      end

      it 'by index' do
        doc = Rindle::Document.find(:first, :indexed => '*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7')
        doc.filename.should == 'A test aswell.mobi'
      end
    end
  end

  describe '.unassociated' do
    it 'should return unassociated documents' do
      docs = Rindle::Document.unassociated
      docs.map(&:filename).should == [ 'This is a test document.rtf' ]
    end
  end

  describe '.find_by_name' do
    it 'should return the document with given path' do
      Rindle::Document.find_by_name('A test aswell.mobi').index.should == '*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7'
    end

    it 'should return nil if not found' do
      Rindle::Document.find_by_name('Non-existent.pdf').should be_nil
    end
  end

  describe '.find_by_index' do
    it 'should return the document with given index' do
      Rindle::Document.find_by_index('*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7').filename.should == 'A test aswell.mobi'
    end

    it 'should return nil if not found' do
      Rindle::Document.find_by_index('*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b6').should be_nil
    end
  end

  describe '#generate_index' do
    it 'should generate an amazon index' do
      Rindle::Document.generate_index('documents/A test aswell.mobi').should == '*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7'
    end

    it 'should generate a non-amazon index' do
      Rindle::Document.
        generate_index('documents/Salvia Divinorum Shamanic Plant-asin_B001UQ5HVA-type_EBSP-v_0.azw').
        should == '#B001UQ5HVA^EBSP'
    end
  end

  describe '#filename' do
    it 'should return the basename of the path' do
      doc = Rindle::Document.find_by_name('A test aswell.mobi')
      doc.filename.should == 'A test aswell.mobi'
    end
  end

  describe '#amazon?' do
    it 'should return true if the filename is an amazon-like name' do
      doc = Rindle::Document.find_by_name('Salvia Divinorum Shamanic Plant-asin_B001UQ5HVA-type_EBSP-v_0.azw')
      doc.amazon?.should == true
    end

    it 'should return false if the filename is not an amazon-like name' do
      doc = Rindle::Document.find_by_name('A test aswell.mobi')
      doc.amazon?.should == false
    end
  end

  describe '#rename!' do
    before :all do
      @doc = Rindle::Document.find_by_name('A test aswell.mobi')
      @doc.rename! 'Indeed a test.mobi'
    end

    after :all do
      @doc.rename! 'A test aswell.mobi'
    end

    it 'should remove the old index' do
      Rindle.index['*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7'].should == nil
    end

    it 'should add the new index' do
      Rindle.index['*c0dc3fee060e3f49c6fd789fa366d99a9334e835'].should == @doc
    end

    it 'should update all references in the collections' do
      col = Rindle::Collection.find_by_name('collection1')
      col.indices.should include(@doc.index)
    end

    it 'should set the new path' do
      @doc.path.should == '/documents/Indeed a test.mobi'
    end
  end

  describe '#collections' do
    it 'should return the associated collections' do
      @doc = Rindle::Document.find_by_name('A test aswell.mobi')
      @doc.collections.map(&:name).should =~ [ 'collection1' ]
    end
  end

end
