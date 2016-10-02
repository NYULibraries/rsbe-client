describe Rsbe::Client::Partner do

  describe ".new" do
    context "with valid attributes and symbol keys" do
      subject { Rsbe::Client::Partner.new(code: 'foo', rel_path: 'f/o/o') }
      it { should be_a(Rsbe::Client::Partner) }
      its(:code)     { should eq 'foo' }
      its(:rel_path) { should eq 'f/o/o' }
    end
    context "with valid attributes and string keys" do
      subject { Rsbe::Client::Partner.new('code' => 'foo', 'rel_path' => 'f/o/o') }
      it { should be_a(Rsbe::Client::Partner) }
      its(:code)     { should eq 'foo' }
      its(:rel_path) { should eq 'f/o/o' }
    end
    context "with incorrect argument type" do
      subject { Rsbe::Client::Partner.new(42) }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
  describe ".base_path" do
    subject { Rsbe::Client::Partner }
    its(:base_path) { should eq '/api/v0/partners' }
  end
  describe ".all", vcr: { cassette_name: 'partner/all' } do
    context "returned array" do
      subject { Rsbe::Client::Partner.all }
      it         { should be_a(Array) }
      its(:size) { should eq 4 }
    end
    context "returned array element" do
      subject { Rsbe::Client::Partner.all[0] }
      it { should be_a(Rsbe::Client::Partner) }
    end
  end

  describe ".find" do
    context "with id of existing Partner", vcr: { cassette_name: 'partner/find-existing' } do
      subject { Rsbe::Client::Partner.find('b110731f-86af-4534-8e58-6d219dcb1c52') }
      its(:class) { should eq Rsbe::Client::Partner }
      its(:id)    { should eq 'b110731f-86af-4534-8e58-6d219dcb1c52' }
      its(:code)  { should eq 'quux' }
    end

    context "with non-existant id", vcr: { cassette_name: 'partner/find-non_existent' } do
      subject { Rsbe::Client::Partner.find('bad45d46-a14a-489f-97ac-384afb552a13') }
      it 'should raise an Rsbe::Client::RecordNotFound' do
        expect { subject }.to raise_error Rsbe::Client::RecordNotFound
      end
    end
  end

  describe "#save" do
    context "when creating a new Partner" do
      context "with valid attributes" do
        context "and no id", vcr: { cassette_name: 'partner/save-create-unknown-id' } do
          let(:partner) { Rsbe::Client::Partner.new(code: 'foo', rel_path: 'f/o/o') }
          subject { partner }
          its(:save) { should eq true }

          context "after save" do
            before { partner.save }
            its(:id)         { should_not be_nil }
            its(:code)       { should eq 'foo'   }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end

        context "and a known id", vcr: {cassette_name: 'partner/save-create-known-id'} do
          let(:partner) do
            Rsbe::Client::Partner.new(id: '51213be7-c8de-4e06-8cc2-06bfc82cdd68',
                                      code: 'bar',
                                      rel_path: 'b/a/r')
          end
          subject { partner }
          its(:save) { should eq true }

          context "after save" do
            before { partner.save }
            its(:id)         { should eq '51213be7-c8de-4e06-8cc2-06bfc82cdd68' }
            its(:code)       { should eq 'bar'   }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end

      context "with invalid attributes", vcr: {cassette_name: 'partner/save-invalid'} do
        let(:partner) { Rsbe::Client::Partner.new(id: 'abc123',
                                                  code: 'baz a saurus',
                                                  rel_path: 'b/a/z') }
        subject { partner }
        its(:save) { should eq false }
      end
    end
    context "when updating a Partner" do
      context "with valid attributes", vcr: {cassette_name: 'partner/save-update-valid'} do
        let(:partner) { Rsbe::Client::Partner.find('b051f936-835c-4abb-9034-efa7508db4bf') }
        subject { partner }
        context "before save-as-update" do
          its(:id)         { should eq 'b051f936-835c-4abb-9034-efa7508db4bf' }
          its(:code)       { should eq 'onyx'  }
          its(:name)       { should     be_nil }
          its(:created_at) { should_not be_nil }
          its(:updated_at) { should_not be_nil }
        end

        context "on save-as-update" do
          before { partner.name = 'The Black Onyx Syndicate' }
          its(:save) { should eq true }
          context "after save" do
            its(:id)         { should eq 'b051f936-835c-4abb-9034-efa7508db4bf' }
            its(:code)       { should eq 'onyx'  }
            its(:name)       { should eq 'The Black Onyx Syndicate' }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end
    end
  end
  describe "#collections" do
    context "when Partner has some collections", vcr: {cassette_name: 'partner/with-collections'} do
      let(:partner) { Rsbe::Client::Partner.find('5c902ffa-b2d9-4b8a-bac6-6ec8cfb50baa') }
      let(:collections) { partner.collections }

      it "should return an Array of Collections" do
        expect(collections).to be_instance_of Array
        expect(collections.first).to be_instance_of Rsbe::Client::Collection
        expect(collections.length).to eq 2
        expect(collections.first.code).to eq 'luke'
      end
    end
    context "when Partner doesn't have any collections", vcr: {cassette_name: 'partner/without-collections'} do
      let(:partner) { Rsbe::Client::Partner.find('51213be7-c8de-4e06-8cc2-06bfc82cdd68') }
      let(:collections) { partner.collections }

      it "should return an Array of Collections" do
        expect(collections).to be_instance_of Array
        expect(collections.length).to eq 0
      end
    end
  end
  describe "lazy evaluation" do
    context "when Partner exists, but is populated with minimal attributes",  vcr: {cassette_name: 'partner/lazy-eval-exists'} do
      let(:partner) { Rsbe::Client::Partner.new(id: 'b051f936-835c-4abb-9034-efa7508db4bf') }
      it "should return values for all attributes" do
        expect(partner.code).to eq 'onyx'
        expect(partner.name).to eq 'The Black Onyx Syndicate'
        expect(partner.rel_path).to eq 'o/n/y/x'
        expect(partner.lock_version).not_to be_nil
        expect(partner.created_at).not_to be_nil
        expect(partner.updated_at).not_to be_nil
      end
    end
    context "when Partner does not exist in RSBE and does not have an id" do
      let(:partner) { Rsbe::Client::Partner.new }
      it "should return values for all attributes" do
        expect(partner.code).to be_nil
        expect(partner.name).to be_nil
        expect(partner.rel_path).to be_nil
        expect(partner.lock_version).to be_nil
        expect(partner.created_at).to be_nil
        expect(partner.updated_at).to be_nil
      end
    end
    context "when Partner does not exist in RSBE but has an id" do
      let(:partner) do
        Rsbe::Client::Partner.new(id: '7c7afee8-c8be-43bf-8096-c03672aaf114',
                                  code: 'topaz')
      end
      it "should return values for defined attributes", vcr: {cassette_name: 'partner/dne-with-id'} do
        expect(partner.code).to eq 'topaz'
        expect(partner.name).to be_nil
        expect(partner.rel_path).to be_nil
        expect(partner.lock_version).to be_nil
        expect(partner.created_at).to be_nil
        expect(partner.updated_at).to be_nil
      end
    end
  end
end
