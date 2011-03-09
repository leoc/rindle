require "spec_helper"

describe Rindle::Filesystem do
  before(:all) do
    Rindle.load(kindle_root)
    @fs = Rindle::Filesystem.new
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
