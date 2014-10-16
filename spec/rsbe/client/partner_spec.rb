describe Rsbe::Client::Partner do

  describe ".new" do
    context "with valid attributes" do
      subject { Rsbe::Client::Partner.new(code: 'foo', rel_path: 'a/b/c') }
      it { should be_a(Rsbe::Client::Partner) }
    end
    context "with incorrect argument type" do
      subject { Rsbe::Client::Partner.new(42) }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe ".find" do
    context "with id of existing Partner", vcr: {cassette_name: 'partner/find-existing'} do
      subject { Rsbe::Client::Partner.find('b110731f-86af-4534-8e58-6d219dcb1c52') }
      its(:class) { should eq Rsbe::Client::Partner }
      its(:id)    { should eq 'b110731f-86af-4534-8e58-6d219dcb1c52' }
      its(:code)  { should eq 'quux' }
    end

    context "with non-existant id", vcr: {cassette_name: 'partner/find-non_existent'} do
      subject { Rsbe::Client::Partner.find('bad45d46-a14a-489f-97ac-384afb552a13') }
      it 'should raise an Rsbe::Client::RecordNotFound' do
        expect { subject }.to raise_error Rsbe::Client::RecordNotFound
      end
    end
  end

  describe "#save" do
    context "when creating a new Partner" do
      context "with valid attributes" do
        context "and no id", vcr: {cassette_name: 'partner/save-unknown-id'} do
          let(:partner) { Rsbe::Client::Partner.new(code: 'foo', rel_path: 'a/b/c') }
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

        context "and a known id", vcr: {cassette_name: 'partner/save-known-id'} do
          let(:partner) do
            Rsbe::Client::Partner.new(id: '51213be7-c8de-4e06-8cc2-06bfc82cdd68',
                                      code: 'bar',
                                      rel_path: 'd/e/f')
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
  end
end
