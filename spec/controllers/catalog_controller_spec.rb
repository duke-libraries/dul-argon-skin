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

    # rubocop:disable RSpec/ExampleLength
    describe 'series_statement' do
      it 'sets the series_statement field' do
        expect(config.search_fields).to have_key('series_statement')
      end

      it 'has a label for the series field' do
        expect(config.search_fields['series_statement'].label).to eq('Series')
      end

      it 'is excluded from simple select dropdown' do
        expect(
          config.search_fields['series_statement'].include_in_simple_select
        ).to be false
      end

      it 'sets the correct Solr defType' do
        expect(config.search_fields['series_statement'].def_type).to(
          eq('edismax')
        )
      end

      it 'sets the solr local parameters' do
        expect(
          config.search_fields['series_statement'].solr_local_parameters
        ).to(
          eq(qf:  'series_statement_indexed_t^20 '\
                  'series_statement_indexed_cjk_v '\
                  'series_statement_indexed_ara_v '\
                  'series_statement_indexed_rus_v',
             pf:  'series_statement_indexed_t^80 '\
                  'series_statement_indexed_cjk_v^20 '\
                  'series_statement_indexed_ara_v^20 '\
                  'series_statement_indexed_rus_v^20',
             pf3: 'series_statement_indexed_t^60 '\
                  'series_statement_indexed_cjk_v^10 '\
                  'series_statement_indexed_ara_v^10 '\
                  'series_statement_indexed_rus_v^10',
             pf2: 'series_statement_indexed_t^40 '\
                  'series_statement_indexed_cjk_v^5 '\
                  'series_statement_indexed_ara_v^5 '\
                  'series_statement_indexed_rus_v^5')
        )
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength

  describe 'home facet fields' do
    it 'sets the access type facet' do
      expect(config.home_facet_fields).to have_key('access_type_f')
    end

    it 'sets the resource type facet' do
      expect(config.home_facet_fields).to have_key('resource_type_f')
    end

    it 'sets the language facet' do
      expect(config.home_facet_fields).to have_key('physical_media_f')
    end

    it 'sets the location hierarchy facet' do
      expect(config.home_facet_fields).to have_key('location_hierarchy_f')
    end

    it 'sets the date cataloged facet' do
      expect(config.home_facet_fields).to have_key('date_cataloged_dt')
    end
  end

  # rubocop:disable RSpec/ExampleLength
  describe 'advanced search configuration' do
    it 'sets the form solr parameters' do
      expect(config.advanced_search[:form_solr_parameters]).to(
        eq('defType' => 'lucene',
           'f.language_f.facet.limit' => -1,
           'f.location_hierarchy_f.facet.limit' => -1,
           'f.physical_media_f.facet.limit' => -1,
           'f.resource_type_f.facet.limit' => -1,
           'facet.field' => %w[available_f
                               access_type_f
                               resource_type_f
                               physical_media_f
                               language_f
                               location_hierarchy_f],
           'facet.limit' => -1,
           'facet.query' => '',
           'facet.sort' => 'index')
      )
    end
  end
  # rubocop:enable RSpec/ExampleLength

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
