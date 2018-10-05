# frozen_string_literal: true

require 'rails_helper'

describe SolrDocument do
  describe 'request_item_url' do
    before do
      allow(DulArgonSkin).to receive(:request_base_url)
        .and_return('https://requests.library.duke.edu')
    end

    let(:solr_document) do
      described_class.new(
        id: 'DUKE012345678'
      )
    end

    it 'returns the URL to the item in DUL Requests app' do
      expect(solr_document.request_item_url).to \
        eq('https://requests.library.duke.edu/item/012345678')
    end
  end

  describe 'duke_requestable?' do
    context 'when item is in Duke collection and at the library' do
      let(:solr_document) do
        described_class.new(
          id: 'DUKE012345678',
          access_type_a: '["At the Library","Online"]'
        )
      end

      before do
        allow(solr_document).to receive(:record_owner).and_return('duke')
      end

      it 'is requestable' do
        expect(solr_document.duke_requestable?).to be true
      end
    end

    context 'when item is at the library, but not in Duke collection' do
      let(:solr_document) do
        described_class.new(
          id: 'UNC012345678',
          access_type_a: '["At the Library"]'
        )
      end

      before do
        allow(solr_document).to receive(:record_owner).and_return('unc')
      end

      it 'is not requestable' do
        expect(solr_document.duke_requestable?).to be false
      end
    end

    context 'when item is in Duke collection, but online-only' do
      let(:solr_document) do
        described_class.new(
          id: 'DUKE012345678',
          access_type_a: '["Online"]'
        )
      end

      before do
        allow(solr_document).to receive(:record_owner).and_return('duke')
      end

      it 'is not requestable' do
        expect(solr_document.duke_requestable?).to be false
      end
    end
  end
end
