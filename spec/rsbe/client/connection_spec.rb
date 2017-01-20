describe Rsbe::Client::Connection do
  let(:same_origin_url) { 'http://localhost:3000/api/v0/partners/2f096796-c685-444f-a4fe-5971346b159d' }
  let(:different_origin_url) { 'http://localhost:3001/api/v0/partners/2f096796-c685-444f-a4fe-5971346b159d' }

  context "when created" do
    subject { Rsbe::Client::Connection.new }
    it { should be_a(Rsbe::Client::Connection) }
  end

  describe "same_origin?" do
    context "with a  url from the same origin" do
      subject { Rsbe::Client::Connection.new.same_origin?(same_origin_url) }
      it { should == true }
    end
    context "with a  url from a different origin" do
      subject { Rsbe::Client::Connection.new.same_origin?(different_origin_url) }
      it { should == false }
    end
  end
end
