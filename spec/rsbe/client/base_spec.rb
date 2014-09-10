describe Rsbe::Client::Base do
  context "when created" do
    subject    { Rsbe::Client::Base.new }
    it         { should be_a(Rsbe::Client::Base) }
  end
end
