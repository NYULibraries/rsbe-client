describe Rsbe::Client::Provider do

  describe ".new" do
    let(:provider_name) { 'James T. Kirk' }
    context "with valid attributes and symbol keys" do
      subject { Rsbe::Client::Provider.new(name: provider_name) }
      it { should be_a(Rsbe::Client::Provider) }
      its(:name) { should eq provider_name }
    end
    context "with valid attributes and string keys" do
      subject { Rsbe::Client::Provider.new('name' => provider_name) }
      it { should be_a(Rsbe::Client::Provider) }
      its(:name) { should eq provider_name }
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

  describe ".find" do
    context "with id of existing Provider", vcr: {cassette_name: 'provider/find-existing'} do
      subject { Rsbe::Client::Provider.find('0938b200-e388-4626-bee8-69b3fc73ecdb') }
      its(:class) { should eq Rsbe::Client::Provider }
      its(:id)    { should eq '0938b200-e388-4626-bee8-69b3fc73ecdb' }
      its(:name)  { should eq 'Portia' }
    end

    context "with non-existant id", vcr: {cassette_name: 'provider/find-non_existent'} do
      subject { Rsbe::Client::Provider.find('bad45d46-a14a-489f-97ac-384afb552a13') }
      it 'should raise an Rsbe::Client::RecordNotFound' do
        expect { subject }.to raise_error Rsbe::Client::RecordNotFound
      end
    end
  end

  describe "#save" do
    context "when creating a new Provider" do
      context "with valid attributes" do
        context "and no id", vcr: {cassette_name: 'provider/save-create-unknown-id'} do
          let(:provider) { Rsbe::Client::Provider.new(name: 'Antony') }
          subject { provider }
          its(:save) { should eq true }

          context "after save" do
            before { provider.save }
            its(:id)         { should_not be_nil  }
            its(:name)       { should eq 'Antony' }
            its(:created_at) { should_not be_nil  }
            its(:updated_at) { should_not be_nil  }
          end

          context "and a known id", vcr: {cassette_name: 'provider/save-create-known-id'} do
            let(:provider) do
              Rsbe::Client::Provider.new(id:   '51213be7-c8de-4e06-8cc2-06bfc82cdd68',
                                         name: 'Octavius')
            end
            subject { provider }
            its(:save) { should eq true }
            context "after save" do
              before { provider.save }
              its(:id)         { should eq '51213be7-c8de-4e06-8cc2-06bfc82cdd68' }
              its(:name)       { should eq 'Octavius' }
              its(:created_at) { should_not be_nil }
              its(:updated_at) { should_not be_nil }
            end
          end
        end
      end

      context "with invalid attributes", vcr: {cassette_name: 'provider/save-invalid'} do
        let(:provider) { Rsbe::Client::Provider.new(id:   'abc123',
                                                    name: '') }
        subject { provider }
        its(:save) { should eq false }
      end
    end

    context "when updating a Provider" do
      context "with valid attributes", vcr: {cassette_name: 'provider/save-update-valid'} do
        let(:provider) { Rsbe::Client::Provider.find('51213be7-c8de-4e06-8cc2-06bfc82cdd68') }
        subject { provider }
        context "before save-as-update" do
          its(:id)         { should eq '51213be7-c8de-4e06-8cc2-06bfc82cdd68' }
          its(:name)       { should eq 'Octavius' }
          its(:created_at) { should_not be_nil }
          its(:updated_at) { should_not be_nil }
        end

        context "on save-as-update" do
          before { provider.name = 'Calpurnia' }
          its(:save) { should eq true }
          context "after save" do
            its(:id)         { should eq '51213be7-c8de-4e06-8cc2-06bfc82cdd68' }
            its(:name)       { should eq 'Calpurnia' }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end
    end
  end
end
