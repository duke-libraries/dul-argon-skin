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
end
