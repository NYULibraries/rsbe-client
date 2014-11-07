describe Rsbe::Client::Base do
  context "when created" do
    subject { Rsbe::Client::Base.new }
    it      { should be_a(Rsbe::Client::Base) }
  end
  describe ".base_path" do
    subject { Rsbe::Client::Base }
    its(:base_path) { should == '/api/v0' }
  end
end
