describe Rsbe::Client::Partner do
  describe ".new" do
    subject { Rsbe::Client::Partner.new }
    it      { should be_a(Rsbe::Client::Partner) }
  end

  describe "#save" do
    context "with valid attributes" do
      subject { Rsbe::Client::Partner.new(code: 'foo', rel_path: 'a/b/c') }
      VCR.use_cassette 'partner/create' do
        its(:save) { should == true }
      end
    end
  end

  # describe ".all" do
  #   # it should return an empty array if no partners in system
  #   # it should return the expected number of partners when there are partners in the system
  #   context "when no partners in system" do
  #     subject { Rsbe::Client::Partner.all }
  #     it { should == [] }
  #   end
  # end
  pending ".find"
  pending "#save" do
    context "when id is known"
    context "when id is unknown"
  end
end
