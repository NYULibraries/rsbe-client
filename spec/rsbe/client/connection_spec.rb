describe Rsbe::Client::Connection do
  context "when created" do
    subject    { Rsbe::Client::Connection.new }
    it         { should be_a(Rsbe::Client::Connection) }
  end
end
