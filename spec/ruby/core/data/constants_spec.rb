require_relative '../../spec_helper'

describe "Data" do
  it "is a subclass of Object" do
    suppress_warning do
      Data.superclass.should == Object
    end
  end

  ruby_version_is "2.5" do
    before :each do
      @deprecated = Warning[:deprecated]
      Warning[:deprecated] = true
    end
    after :each do
      Warning[:deprecated] = @deprecated
    end
    it "is deprecated" do
      -> { Data }.should complain(/constant ::Data is deprecated/)
    end
  end
end
