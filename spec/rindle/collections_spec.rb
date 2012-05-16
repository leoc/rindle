require "spec_helper"

describe Rindle::Collections do
  it 'loads the kindles collections.json file' do
    collections = Rindle::Collections.load(kindle_root)
    Hash[collections.map{|k,c| [k,c.indices] } ].should == {
      "collection1"  => ["*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", "*0849dd9b85fc341d10104f56985e423b3848e1f3"],
      "collection2"  => ["*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2"],
      "amazon books" => ["#B001UQ5HVA^EBSP","#B000JQU1VS^EBOK"]
    }
  end
end
