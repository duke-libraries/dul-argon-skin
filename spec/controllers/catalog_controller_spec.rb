# frozen_string_literal: true

require 'rails_helper'
describe CatalogController do
  let(:config) { subject.blacklight_config }

  describe 'default solr params' do
    it 'sets the defaults solr params' do
      expect(config.default_solr_params).to(
        eq(lowercaseOperators: 'false', rows: 10)
      )
    end
  end

  describe 'show_fields' do
    describe 'local_id' do
      it 'sets the local_id field to display' do
        expect(config.show_fields).to have_key('local_id')
      end

      it 'has a label for local_id' do
        expect(config.show_fields['local_id'].label).to eq('System ID')
      end
    end

    describe 'donor' do
      it 'sets the donor field to display' do
        expect(config.show_fields).to have_key('donor_a')
      end

      it 'has a label for donor' do
        expect(config.show_fields['donor_a'].label).to eq('Bookplate')
      end

      it 'applies the donor span helper method' do
        expect(config.show_fields['donor_a'].helper_method).to(
          eq(:add_donor_span)
        )
      end
    end
  end

  describe 'search fields' do
    describe 'call_number' do
      it 'sets the call_number field' do
        expect(config.search_fields).to have_key('call_number')
      end

      it 'has a label for the call_number field' do
        expect(config.search_fields['call_number'].label).to(
          eq('Call Number')
        )
      end
    end

    describe 'origin_place' do
      let(:solr_params_exp) do
        YAML.safe_load(
          file_fixture('solr_parameters/origin_place_exp.yml').read, [Symbol]
        )
      end

      it 'sets the origin_place field' do
        expect(config.search_fields).to have_key('origin_place')
      end

      it 'has a label for the series field' do
        expect(config.search_fields['origin_place'].label).to(
          eq('Place of Publication')
        )
      end

      it 'is excluded from simple select dropdown' do
        expect(
          config.search_fields['origin_place'].include_in_simple_select
        ).to be false
      end

      it 'sets the correct Solr defType' do
        expect(config.search_fields['origin_place'].def_type).to(
          eq('edismax')
        )
      end

      it 'sets the solr local parameters' do
        expect(
          config.search_fields['origin_place'].solr_local_parameters
        ).to eq(solr_params_exp)
      end
    end
  end

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

  describe 'call_number queries' do
    before { skip('Skipping call number tests. Useful but brittle.') }

    it 'finds HT127.5 .S465' do
      get :index, params: { q: 'HT127.5 .S465', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE004209367')
    end

    it 'finds P123 .J34 1974 c.1' do
      get :index,
          params: { q: 'P123 .J34 1974 c.1', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000547802')
    end

    it 'finds P123 .J34 1972' do
      get :index, params: { q: 'P123 .J34 1972', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE001353979')
    end

    it 'finds P123 .J34' do
      get :index, params: { q: 'P123 .J34', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE001353979')
    end

    it 'finds LB2351.2 .S755 2007' do
      get :index,
          params: { q: 'LB2351.2 .S755 2007', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003897886')
    end

    it 'finds LB2351.2 .S755 2007 c.1' do
      get :index, params: { q: 'LB2351.2 .S755 2007 c.1',
                            search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003897886')
    end

    it 'finds LB2351.2 .S755' do
      get :index, params: { q: 'LB2351.2 .S755', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003897886')
    end

    it 'finds DD207.5 .M26 1975 Bd.2 c.1' do
      get :index, params: { q: 'DD207.5 .M26 1975 Bd.2 c.1',
                            search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000205600')
    end

    it 'finds DD207.5 .M26 1975' do
      get :index,
          params: { q: 'DD207.5 .M26 1975', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000205600')
    end

    it 'does not find PS3537 A83' do
      get :index, params: { q: 'PS3537 A83', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to eq([])
    end

    it 'finds all matches for PS3537.A832' do
      get :index, params: { q: 'PS3537.A832', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id).count).to be > 10
    end

    it 'finds PS3563.O8749 B4' do
      get :index, params: { q: 'PS3563.O8749 B4', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE000738630')
    end

    it 'does not find partials of PS3563.O8749 B4' do
      get :index, params: { q: 'PS3563.O8749 B4', search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).not_to include('DUKE007451897')
    end

    it 'finds PS3563.O8749 B4 2006' do
      get :index, params: { q: 'PS3563.O8749 B4 2006',
                            search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE003835769')
    end

    it 'finds PS3563.O8749 B4 1998b c.3' do
      get :index, params: { q: 'PS3563.O8749 B4 1998b c.3',
                            search_field: 'call_number' }
      expect(assigns(:document_list).map(&:id)).to include('DUKE002544061')
    end
  end
end
