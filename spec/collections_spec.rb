require "spec_helper"

describe Kindle::Collections do
  it 'loads the kindles collections.json file' do
    collections = Kindle::Collections.load(kindle_root)
    collections.should == {
      "collection1@en-US" => {
        "items" => ["*18be6fcd5d5df39c1a96cd22596bbe7fe01db9b7", "*0849dd9b85fc341d10104f56985e423b3848e1f3"],
        "lastAccess" => 1298745909919
      },
      "collection2@en-US" => {
        "items" => ["*440f49b58ae78d34f4b8ad3233f04f6b8f5490c2"],
        "lastAccess" => 1298745909918
      },
      "amazon books@en-US" => {
        "items" => ["#B001UQ5HVA^EBSP","#B000JQU1VS^EBOK"]
      }
    }
  end
end
