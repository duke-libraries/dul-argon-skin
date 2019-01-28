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
end
