describe Rsbe::Client::Provider do

  describe ".new" do
    context "with valid attributes" do
      subject { Rsbe::Client::Provider.new(code: 'foo', rel_path: 'f/o/o') }
      it { should be_a(Rsbe::Client::Provider) }
    end
    context "with incorrect argument type" do
      subject { Rsbe::Client::Provider.new(42) }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe ".base_path" do
    subject { Rsbe::Client::Provider }
    its(:base_path) { should eq '/api/v0/providers' }
  end

  describe ".all", vcr: {cassette_name: 'provider/all'} do
    context "returned array" do
      subject { Rsbe::Client::Provider.all }
      it         { should be_a(Array) }
      its(:size) { should eq 4 }
    end
    context "returned array element" do
      subject { Rsbe::Client::Provider.all[0] }
      it { should be_a(Rsbe::Client::Provider) }
    end
  end
end
