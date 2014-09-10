describe Rsbe::Client::Partner do
  context "when created" do
    subject { Rsbe::Client::Partner.new }
    it      { should be_a(Rsbe::Client::Partner) }
  end
end
