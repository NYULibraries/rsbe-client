describe Rsbe::Client::Partner do
  describe ".new" do
    subject { Rsbe::Client::Partner.new }
    it      { should be_a(Rsbe::Client::Partner) }
  end

  describe "#save", vcr: {cassette_name: 'partner/save'} do
    context "with valid attributes" do
      subject { Rsbe::Client::Partner.new(code: 'foo', rel_path: 'a/b/c') }
      its(:save) do
        should eq true
      end
    end
  end
  pending ".find"
  pending "#save" do
    context "when id is known"
    context "when id is unknown"
  end
end
