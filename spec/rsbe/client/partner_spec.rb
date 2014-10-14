describe Rsbe::Client::Partner do

  describe ".new" do
    subject { Rsbe::Client::Partner.new(code: 'foo', rel_path: 'a/b/c') }
    it { should be_a(Rsbe::Client::Partner) }
  end


  describe "#save" do
    context "with valid attributes, unknown id", vcr: {cassette_name: 'partner/save-unknown-id'}do
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

    context "with valid attributes, known id", vcr: {cassette_name: 'partner/save-known-id'} do
      let(:partner) { Rsbe::Client::Partner.new(id: '51213be7-c8de-4e06-8cc2-06bfc82cdd68', code: 'bar', rel_path: 'd/e/f') }
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
end
