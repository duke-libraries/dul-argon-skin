# frozen_string_literal: true

require 'rails_helper'
describe CatalogController do
  let(:config) { subject.blacklight_config }

  describe 'search fields' do
    describe 'shelfkey' do
      it 'sets the shelfkey field' do
        expect(config.search_fields).to have_key('shelfkey')
      end

      it 'has a label for the shelfkey field' do
        expect(config.search_fields['shelfkey'].label).to eq('Call Number (LC)')
      end
    end
  end

  describe 'shelfkey queries' do
    before { skip('Skipping call number tests. Useful but brittle.') }

    it 'finds HT127.5 .S465' do
      get :index, params: { q: 'HT127.5 .S465', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE004209367')
    end

    it 'finds P123 .J34 1974 c.1' do
      get :index, params: { q: 'P123 .J34 1974 c.1', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000547802')
    end

    it 'finds P123 .J34 1972' do
      get :index, params: { q: 'P123 .J34 1972', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE001353979')
    end

    it 'finds P123 .J34' do
      get :index, params: { q: 'P123 .J34', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE001353979')
    end

    it 'finds LB2351.2 .S755 2007' do
      get :index, params: { q: 'LB2351.2 .S755 2007', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003897886')
    end

    it 'finds LB2351.2 .S755 2007 c.1' do
      get :index, params: { q: 'LB2351.2 .S755 2007 c.1',
                            search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003897886')
    end

    it 'finds LB2351.2 .S755' do
      get :index, params: { q: 'LB2351.2 .S755', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003897886')
    end

    it 'finds DD207.5 .M26 1975 Bd.2 c.1' do
      get :index, params: { q: 'DD207.5 .M26 1975 Bd.2 c.1',
                            search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000205600')
    end

    it 'finds DD207.5 .M26 1975' do
      get :index, params: { q: 'DD207.5 .M26 1975', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000205600')
    end

    it 'does not find PS3537 A83' do
      get :index, params: { q: 'PS3537 A83', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to eq([])
    end

    it 'finds all matches for PS3537.A832' do
      get :index, params: { q: 'PS3537.A832', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id).count).to be > 10
    end

    it 'finds PS3563.O8749 B4' do
      get :index, params: { q: 'PS3563.O8749 B4', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000738630')
    end

    it 'does not find partials of PS3563.O8749 B4' do
      get :index, params: { q: 'PS3563.O8749 B4', search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).not_to include('DUKE007451897')
    end

    it 'finds PS3563.O8749 B4 2006' do
      get :index, params: { q: 'PS3563.O8749 B4 2006',
                            search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003835769')
    end

    it 'finds PS3563.O8749 B4 1998b c.3' do
      get :index, params: { q: 'PS3563.O8749 B4 1998b c.3',
                            search_field: 'shelfkey' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE002544061')
    end
  end
end
