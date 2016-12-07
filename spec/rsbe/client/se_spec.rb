describe Rsbe::Client::Collection do

  describe ".new" do
    context "with valid attributes and symbol keys" do
      subject { Rsbe::Client::Se.new(coll_id: 'ea85c776-a79b-4603-b307-d6760a400281', digi_id: 'boo', do_type: 'audio', phase: 'digitization', step: 'qc', status: 'pause', label:'why label anything?', notes: 'notes') }
      it { should be_a(Rsbe::Client::Se) }
      its(:coll_id)     { should eq 'ea85c776-a79b-4603-b307-d6760a400281' }
      its(:digi_id) { should eq 'boo' }
      its(:do_type) { should eq 'audio' }
      its(:phase) { should eq 'digitization' }
      its(:step) { should eq 'qc' }
      its(:status) { should eq 'pause' }
      its(:label) { should eq 'why label anything?' }
      its(:notes) { should eq 'notes' }
    end
    context "with incorrect argument type" do
      subject { Rsbe::Client::Se.new(24) }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe ".base_path" do
    subject { Rsbe::Client::Se }
    its(:base_path) { should eq '/api/v0/se' }
  end

  describe ".all" do
    subject { Rsbe::Client::Se.all }
    it 'should raise a MethodNotImplementedError' do
      expect { subject }.to raise_error Rsbe::Client::MethodNotImplementedError
    end
  end

  describe ".find" do
    context "with id of existing Se", vcr: {cassette_name: 'se/find-existing'} do
      subject { Rsbe::Client::Se.find('acf51ef2-8bf3-4f05-9042-0bfcb6860560') }
      its(:class) { should eq Rsbe::Client::Se }
      its(:id)    { should eq 'facf51ef2-8bf3-4f05-9042-0bfcb6860560' }
      its(:digi_id)  { should eq 'foo_quux_cuid01234' }
    end

    context "with non-existent id", vcr: {cassette_name: 'se/find-non_existent'} do
      subject { Rsbe::Client::Collection.find('baddoh-a14a-489f-97ac-384afb552a13') }
      it 'should raise an Rsbe::Client::RecordNotFound' do
        expect { subject }.to raise_error Rsbe::Client::RecordNotFound
      end
    end
  end

  describe "#save" do
    context "when creating a new Se" do
      context "with valid attributes" do
        # TODO: implment FactoryGirl
        context "and no id", vcr: {cassette_name: 'se/save-create-unknown-id'} do
          let(:coll_id) { "ea85c776-a79b-4603-b307-d6760a400281" }
          let(:digi_id) { 'magnum_est_dorp0987' }
          let(:do_type) { 'map' }
          let(:phase)  { 'upload' }
          let(:step)  { 'packaging' }
          let(:status)  { 'done' }
          let(:label)  { 'whee labels' }
          let(:notes)  { 'lorem ipsum dolor' }
          let(:se) { Rsbe::Client::Se.new(coll_id: coll_id,
                                                          digi_id:  digi_id,
                                                          do_type: do_type,
                                                          phase:  phase,
                                                          step: step,
                                                          status: status,
                                                          label: label,
                                                          notes: notes) }
          subject { se }
          its(:save) { should eq true }

          context "after save" do
            before { se.save }
            its(:id)         { should_not be_nil }
            its(:coll_id) { should eq 'ea85c776-a79b-4603-b307-d6760a400281' }
            its(:digi_id)       { should eq digi_id    }
            its(:do_type)      { should eq do_type   }
            its(:phase)       { should eq phase    }
            its(:step)       { should eq step    }
            its(:status)       { should eq status    }
            its(:label)       { should eq label    }
            its(:notes)       { should eq notes    }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end

        context "and a known id", vcr: {cassette_name: 'se/save-create-known-id'} do
          let(:se) do
            Rsbe::Client::Se.new(id:         '07998216-af0a-4262-b7f9-6a7d9c4aeae4',
                                         coll_id: 'ea85c776-a79b-4603-b307-d6760a400281',
                                         digi_id: 'AD-MC-0023',
                                         do_type: 'map',
                                         phase:  'upload',
                                         step: 'qc',
                                         status: 'done',
                                         label: 'label',
                                         notes: 'notes')
          end
          subject { se }
          its(:save) { should eq true }

          context "after save" do
            before { se.save }
            its(:id)         { should eq '07998216-af0a-4262-b7f9-6a7d9c4aeae4' }
            its(:coll_id) { should eq 'ea85c776-a79b-4603-b307-d6760a400281' }
            its(:digi_id)       { should eq 'AD-MC-0023'    }
            its(:do_type)      { should eq 'map'   }
            its(:phase)       { should eq 'upload'    }
            its(:step)       { should eq 'qc'    }
            its(:status)       { should eq 'done'    }
            its(:label)       { should eq 'label'    }
            its(:notes)       { should eq 'notes'    }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end
      context "with invalid attributes", vcr: {cassette_name: 'se/save-invalid'} do
        let(:se) do
          Rsbe::Client::Collection.new(coll_id: 'ea85c776-a79b-4603-b307-d6760a400281',
                                       phase:  'new moon')
        end
        subject { se }
        its(:save) { should eq false }
      end
    end
    # start work on this
    context "when updating a Collection" do
      context "with valid attributes", vcr: {cassette_name: 'se/save-update-valid'} do
        let(:se) { Rsbe::Client::Se.find('07998216-af0a-4262-b7f9-6a7d9c4aeae4') }
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
  describe "lazy evaluation" do
    context "when Collection exists, but is populated with minimal attributes", vcr: {cassette_name: 'collection/lazy-eval-exists'} do
      let(:collection) { Rsbe::Client::Collection.new(id: 'fc7455cf-3b20-494c-9b9e-17cae9e51fa1') }
      it "should return values for all attributes" do
        expect(collection.code).to eq 'zaap'
        expect(collection.name).to eq 'Zoinks and Away, Potatoes!'
        expect(collection.quota).to eq 500
        expect(collection.coll_type).to eq 'origin'
        expect(collection.lock_version).not_to be_nil
        expect(collection.created_at).not_to be_nil
        expect(collection.updated_at).not_to be_nil
      end
    end
    context "when Collection does not exist in RSBE and does not have an id" do
      let(:collection) { Rsbe::Client::Collection.new }
      it "should return nil for all attributes" do
        expect(collection.id).to be_nil
        expect(collection.code).to be_nil
        expect(collection.name).to be_nil
        expect(collection.quota).to be_nil
        expect(collection.coll_type).to be_nil
        expect(collection.lock_version).to be_nil
        expect(collection.created_at).to be_nil
        expect(collection.updated_at).to be_nil
      end
    end
    context "when Collection does not exist in RSBE but has an id", vcr: {cassette_name: 'collection/lazy-eval-dne'} do
      let(:collection) do
        Rsbe::Client::Collection.new(id: '7c7afee8-c8be-43bf-8096-c03672aaf114',
                                     code: 'flippers')
      end
      it "should return values for defined attributes" do
        expect(collection.id).to eq '7c7afee8-c8be-43bf-8096-c03672aaf114'
        expect(collection.code).to eq 'flippers'
        expect(collection.name).to be_nil
        expect(collection.quota).to be_nil
        expect(collection.coll_type).to be_nil
        expect(collection.lock_version).to be_nil
        expect(collection.created_at).to be_nil
        expect(collection.updated_at).to be_nil
      end
    end
  end
end
