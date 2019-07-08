# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe 'search_session_includes_ajax_request?' do
    context 'when there is no format specified' do
      let(:current_search) do
        Search.create(query_params: { q: 'May Sarton' })
      end

      it 'is NOT identified as an ajax search session' do
        expect(helper.search_session_includes_ajax_request?(current_search)).to(
          be false
        )
      end
    end

    context 'when there is a json format specified' do
      let(:current_search) do
        Search.create(query_params: { q: 'May Sarton', 'format' => 'json' })
      end

      it 'is identified as an ajax search session' do
        expect(helper.search_session_includes_ajax_request?(current_search)).to(
          be true
        )
      end
    end
  end

  describe 'search_session_includes_catalog_controller?' do
    context 'when search session includes catalog controller param' do
      let(:current_search) do
        Search.create(query_params: { controller: 'trln' })
      end

      it 'is identified as a catalog controller session' do
        expect(
          helper.search_session_includes_catalog_controller?(
            current_search
          )
        ).to(be true)
      end
    end

    context 'when search session includes advanced controller param' do
      let(:current_search) do
        Search.create(query_params: { controller: 'advanced' })
      end

      it 'is NOT identified as a catalog controller session' do
        expect(
          helper.search_session_includes_catalog_controller?(
            current_search
          )
        ).to(be false)
      end
    end
  end

  describe 'show_hathitrust_link_if_available?' do
    context 'when document is a book' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE123456789',
          oclc_number: '123456',
          resource_type_a: ['Book']
        )
      end

      it 'returns true' do
        expect(helper.show_hathitrust_link_if_available?(document)).to be true
      end
    end

    context 'when document is a serial with issues after 1923' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE123456789',
          oclc_number: '123456',
          resource_type_a: ['Journal, Magazine, or Periodical'],
          publication_year_sort: '1999'
        )
      end

      it 'returns false' do
        expect(helper.show_hathitrust_link_if_available?(document)).to be false
      end
    end

    context 'when document is a serial and publication ended before 1924' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE123456789',
          oclc_number: '123456',
          resource_type_a: ['Journal, Magazine, or Periodical'],
          publication_year_sort: '1890'
        )
      end

      it 'returns true' do
        expect(helper.show_hathitrust_link_if_available?(document)).to be true
      end
    end

    context 'when document is a serial and a government document' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE123456789',
          oclc_number: '123456',
          resource_type_a: ['Journal, Magazine, or Periodical',
                            'Government publication'],
          publication_year_sort: '1999'
        )
      end

      it 'returns true' do
        expect(helper.show_hathitrust_link_if_available?(document)).to be true
      end
    end

    context 'when document is a serial and does not include a pub date' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE123456789',
          oclc_number: '123456',
          resource_type_a: ['Journal, Magazine, or Periodical']
        )
      end

      it 'returns false' do
        expect(helper.show_hathitrust_link_if_available?(document)).to be false
      end
    end
  end

  describe 'strip_duke_id_prefix' do
    context 'when record has a DUKE prefix in its Local ID' do
      let(:document) do
        SolrDocument.new(
          YAML.safe_load(file_fixture('documents/DUKE006162724.yml').read)
        )
      end

      it 'returns the ID with DUKE stripped out' do
        expect(strip_duke_id_prefix(document: document)).to(eq('006162724'))
      end
    end

    context 'when record has no DUKE prefix in its Local ID' do
      let(:document) do
        SolrDocument.new(
          YAML.safe_load(file_fixture('documents/UNCb1852218.yml').read)
        )
      end

      it 'returns the Local ID unchanged' do
        expect(strip_duke_id_prefix(document: document)).to(eq('b1852218'))
      end
    end
  end

  describe 'add_bookplate_span' do
    let(:value) do
      { value: ['Acquired as part of the Leona Bowman Carpenter Collection',
                'Gift of the Leona Bowman Carpenter collection'] }
    end

    it 'wraps the bookplate note in a span' do
      expect(add_bookplate_span(value)).to(
        eq('Acquired as part of the Leona Bowman Carpenter Collection<br/>'\
           '<span class="dul-bookplate">'\
           'Gift of the Leona Bowman Carpenter collection</span>')
      )
    end
  end
end
