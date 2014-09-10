describe Rsbe::Client::Partner do
  describe ".new" do
    subject { Rsbe::Client::Partner.new }
    it      { should be_a(Rsbe::Client::Partner) }
  end

  pending ".all"
  pending ".find"
  pending "#save" do
    context "when id is known"
    context "when id is unknown"
  end
end
