require "spec_helper"

describe Rindle::Filesystem do
  before(:all) do
    Rindle.load(kindle_root)
    @fs = Rindle::Filesystem.new
  end

  context '#file?' do
    it 'returns true if path to document given' do
      @fs.file?('/collections/collection1/A test aswell.mobi').should == true
    end

    it 'returns false if path to collection given' do
      @fs.file?('/collections/collection1').should == false
    end
  end

  context '#directory?' do
    it 'returns true if path to collection given' do
      @fs.directory?('/collections/collection1').should == true
    end

    it 'returns false if path to document given' do
      @fs.directory?('/collections/collection1/A test aswell.mobi').should == false
    end
  end
  
  context '#contents' do
    it 'lists view options' do
      list = @fs.contents('/')
      list.should =~ [ 'collections', 'books', 'pictures' ]
    end
    it 'lists collections' do
      list = @fs.contents('/collections')
      list.should =~ [ 'collection1', 'collection2', 'amazon books' ]
    end
    it 'lists documents in a collection' do
      list = @fs.contents('/collections/collection1')
      list.should =~ [ 'A test aswell.mobi', 'Definitely a Test.pdf' ]
    end
  end
end
