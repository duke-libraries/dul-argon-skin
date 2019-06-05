# frozen_string_literal: true

require 'rails_helper'

describe GoogleAnalyticsHelper do
  describe 'ga_catalog_scope' do
    context 'when page uses catalog controller' do
      before do
        allow(controller).to receive(:controller_name).and_return('catalog')
      end

      it 'is considered in Duke scope' do
        expect(helper.ga_catalog_scope).to eq('Duke')
      end
    end

    context 'when page uses trln controller' do
      before do
        allow(controller).to receive(:controller_name).and_return('trln')
      end

      it 'is considered in TRLN scope' do
        expect(helper.ga_catalog_scope).to eq('TRLN')
      end
    end

    context 'when page uses advanced search controller' do
      before do
        allow(controller).to receive(:controller_name).and_return('advanced')
      end

      it 'is considered in Neutral scope' do
        expect(helper.ga_catalog_scope).to eq('Neutral')
      end
    end
  end

  describe 'ga_page_type' do
    context 'with search results page with no results' do
      before do
        allow(helper).to receive(:search_results_page_zero_results?)\
          .and_return(true)
      end

      it 'is considered a No Results page' do
        expect(helper.ga_page_type).to eq('No Results Page')
      end
    end

    context 'with search results page that has results' do
      before do
        allow(helper).to receive(:search_results_page_zero_results?)\
          .and_return(false)
        allow(helper).to receive(:search_results_page_with_results?)\
          .and_return(true)
      end

      it 'is considered a Search Results page' do
        expect(helper.ga_page_type).to eq('Search Results Page')
      end
    end

    context 'with advanced search page' do
      before do
        allow(helper).to receive(:advanced_search_page?).and_return(true)
      end

      it 'is considered an Advanced Search page' do
        expect(helper.ga_page_type).to eq('Advanced Search Page')
      end
    end

    context 'with any homepage URL' do
      before do
        allow(helper).to receive(:home_page?).and_return(true)
      end

      it 'is considered a Homepage' do
        expect(helper.ga_page_type).to eq('Homepage')
      end
    end

    context 'with an item show page' do
      before do
        allow(helper).to receive(:item_show_page?).and_return(true)
      end

      it 'is considered an Item Page' do
        expect(helper.ga_page_type).to eq('Item Page')
      end
    end

    context 'with a 404 page' do
      before do
        allow(helper).to receive(:error_404_page?).and_return(true)
      end

      it 'is considered an Item Page' do
        expect(helper.ga_page_type).to eq('404 Page')
      end
    end

    context 'with a bookmarks page' do
      before do
        allow(helper).to receive(:bookmarks_page?).and_return(true)
      end

      it 'is considered a Bookmarks Page' do
        expect(helper.ga_page_type).to eq('Bookmarks Page')
      end
    end

    context 'with a page that does not match any of the defined types' do
      before do
        allow(helper).to receive(:search_results_page_zero_results?)\
          .and_return(false)
        allow(helper).to receive(:search_results_page_with_results?)\
          .and_return(false)
        allow(helper).to receive(:advanced_search_page?).and_return(false)
        allow(helper).to receive(:home_page?).and_return(false)
        allow(helper).to receive(:item_show_page?).and_return(false)
        allow(helper).to receive(:error_404_page?).and_return(false)
        allow(helper).to receive(:bookmarks_page?).and_return(false)
      end

      it 'is considered an Other Page' do
        expect(helper.ga_page_type).to eq('Other Page')
      end
    end
  end
end
