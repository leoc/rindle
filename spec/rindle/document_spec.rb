require "spec_helper"

describe Rindle::Document do
  before(:all) do
    Rindle.load(kindle_root)
  end

  after(:all) do
    Rindle.reset
  end

  it 'equals another if the index is the same' do
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
end
