# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe 'search_session_contains_ajax_request?' do
    context 'when there is no format specified' do
      let(:current_search) do
        Search.create(query_params: { q: 'May Sarton' })
      end

      it 'is NOT identified as an ajax search session' do
        expect(helper.search_session_contains_ajax_request?(current_search)).to(
          be false
        )
      end
    end

    context 'when there is a json format specified' do
      let(:current_search) do
        Search.create(query_params: { q: 'May Sarton', 'format' => 'json' })
      end

      it 'is identified as an ajax search session' do
        expect(helper.search_session_contains_ajax_request?(current_search)).to(
          be true
        )
      end
    end
  end
end
