describe Rsbe::Client::Collection do
  # class Coll < ActiveRecord::Base
  #   belongs_to :partner
  #   has_many   :fmds

  #   validates :code,       presence: true, uniqueness: {scope: :partner_id}
  #   validates :code,       format: { with: /\A[a-z\d\-_]+\z/,
  #     message: 'invalid character in code' }
  #   validates :partner_id, presence: true
  #   validates :coll_type,  presence: true, inclusion:  {in: %w(origin virtual)}
  #   validates :quota,      presence: true, numericality: { only_integer: true,
  #     greater_than_or_equal_to: 0 }

  # end

  describe ".new" do
    context "with valid attributes" do
      subject { Rsbe::Client::Collection.new(code: 'foo', rel_path: 'f/o/o') }
      it { should be_a(Rsbe::Client::Collection) }
    end
    context "with incorrect argument type" do
      subject { Rsbe::Client::Collection.new(42) }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe ".base_path" do
    subject { Rsbe::Client::Collection }
    its(:base_path) { should eq '/api/v0/colls' }
  end

  describe ".all" do
    subject { Rsbe::Client::Collection.all }
    it 'should raise a MethodNotImplementedError' do
      expect { subject }.to raise_error Rsbe::Client::MethodNotImplementedError
    end
  end

  describe ".find" do
    context "with id of existing Collection", vcr: {cassette_name: 'collection/find-existing'} do
      subject { Rsbe::Client::Collection.find('fc7455cf-3b20-494c-9b9e-17cae9e51fa1') }
      its(:class) { should eq Rsbe::Client::Collection }
      its(:id)    { should eq 'fc7455cf-3b20-494c-9b9e-17cae9e51fa1' }
      its(:code)  { should eq 'zaap' }
    end

    context "with non-existant id", vcr: {cassette_name: 'collection/find-non_existent'} do
      subject { Rsbe::Client::Collection.find('bad45d46-a14a-489f-97ac-384afb552a13') }
      it 'should raise an Rsbe::Client::RecordNotFound' do
        expect { subject }.to raise_error Rsbe::Client::RecordNotFound
      end
    end
  end

  describe "#save" do
    context "when creating a new Collection" do
      context "with valid attributes" do
        # TODO: implment FactoryGirl
        context "and no id", vcr: {cassette_name: 'collection/save-create-unknown-id'} do
          let(:partner_id) { "5c902ffa-b2d9-4b8a-bac6-6ec8cfb50baa" }
          let(:code) { 'luke' }
          let(:quota) { 1024 }
          let(:name)  { 'Lasers Under Kinetic Ether' }
          let(:coll_type) { 'origin' }
          let(:collection) { Rsbe::Client::Collection.new(partner_id: partner_id,
                                                          code:  code,
                                                          quota: quota,
                                                          name:  name,
                                                          coll_type: coll_type) }
          subject { collection }
          its(:save) { should eq true }

          context "after save" do
            before { collection.save }
            its(:id)         { should_not be_nil }
            its(:partner_id) { should eq '5c902ffa-b2d9-4b8a-bac6-6ec8cfb50baa' }
            its(:code)       { should eq code    }
            its(:quota)      { should eq quota   }
            its(:name)       { should eq name    }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end

        context "and a known id", vcr: {cassette_name: 'collection/save-create-known-id'} do
          let(:collection) do
            Rsbe::Client::Collection.new(id:         '07998216-af0a-4262-b7f9-6a7d9c4aeae4',
                                         partner_id: '5c902ffa-b2d9-4b8a-bac6-6ec8cfb50baa',
                                         code:       'han',
                                         name:       'Happy Anteaters of Nigeria',
                                         quota:      123,
                                         coll_type:  'origin')
          end
          subject { collection }
          its(:save) { should eq true }

          context "after save" do
            before { collection.save }
            its(:id)         { should eq '07998216-af0a-4262-b7f9-6a7d9c4aeae4' }
            its(:partner_id) { should eq '5c902ffa-b2d9-4b8a-bac6-6ec8cfb50baa' }
            its(:code)       { should eq 'han'   }
            its(:name)       { should eq 'Happy Anteaters of Nigeria' }
            its(:quota)      { should eq 123 }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end
      context "with invalid attributes", vcr: {cassette_name: 'collection/save-invalid'} do
        let(:collection) do
          Rsbe::Client::Collection.new(partner_id: '5c902ffa-b2d9-4b8a-bac6-6ec8cfb50baa',
                                       coll_type:  'banana frappe')
        end
        subject { collection }
        its(:save) { should eq false }
      end
    end
    context "when updating a Collection" do
      context "with valid attributes", vcr: {cassette_name: 'collection/save-update-valid'} do
        let(:collection) { Rsbe::Client::Collection.find('07998216-af0a-4262-b7f9-6a7d9c4aeae4') }
        subject { collection }
        context "before save-as-update" do
          its(:id)         { should eq '07998216-af0a-4262-b7f9-6a7d9c4aeae4' }
          its(:code)       { should eq 'han'  }
          its(:name)       { should eq 'Happy Anteaters of Nigeria' }
          its(:created_at) { should_not be_nil }
          its(:updated_at) { should_not be_nil }
        end
        context "on save-as-update" do
          before do
            collection.name = 'Last Emu In Australia'
            collection.code = 'leia'
          end
          its(:save) { should eq true }
          context "after save" do
            its(:id)         { should eq '07998216-af0a-4262-b7f9-6a7d9c4aeae4' }
            its(:code)       { should eq 'leia'  }
            its(:name)       { should eq 'Last Emu In Australia' }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end
    end
  end
end
