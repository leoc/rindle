require "spec_helper"

describe Rindle::Index do
  before(:each) do
    @index = Rindle::Index.new
  end

  context '#add' do
    it 'generates and adds for sha1 sum for custom books' do
      index = @index.add('documents/A test aswell.mobi')
      index.should == "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7"
      @index.should have_key("*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7")
    end
    it 'generates and adds amazon indices for EBOK and EBSP files' do
      index = @index.add('documents/Salvia Divinorum Shamanic Plant-asin_B001UQ5HVA-type_EBSP-v_0.azw')
      index.should == "#B001UQ5HVA^EBSP"
      @index.should have_key("#B001UQ5HVA^EBSP")
    end
  end
  
  context '#new' do
    it 'creates an empty index' do
      @index.should be_empty
    end
    
    it 'derives from Hash' do
      @index.should be_a(Hash)
    end
  end

  it 'is not empty after #load if there are documents on the kindle' do
    Dir[File.join(kindle_root, '{documents,pictures}', '*.{mobi,azw,azw1,pdf}')].should_not be_empty
    Rindle::Index.load(kindle_root).should_not == {}
  end
  
  it 'indexes the dummy files from spec data' do
    @index = Rindle::Index.load(kindle_root)
    @index.should == {
      "*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7" => "/documents/A test aswell.mobi",
      "#B001UQ5HVA^EBSP" => "/documents/Salvia Divinorum Shamanic Plant-asin_B001UQ5HVA-type_EBSP-v_0.azw",
      "*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2" => "/documents/A book in another collection.mobi",
      "#B000JQU1VS^EBOK" => "/documents/The Adventures of Sherlock Holme-asin_B000JQU1VS-type_EBOK-v_0.azw",
      "*0849dd9b85fc341d10104f56985e423b3848e1f3" => "/documents/Definitely a Test.pdf"
    }
  end
end
