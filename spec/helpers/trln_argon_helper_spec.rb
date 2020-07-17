# frozen_string_literal: true

require 'rails_helper'

describe TrlnArgonHelper do
  describe '#add_thumbnail' do
    context 'when the MARC provided URL is NOT HTTPS' do
      let(:doc) do
        SolrDocument.new(
          id: 'DUKE012345678',
          url_a: ['"href":"http://images.contentreserve.com/Img200.jpg",'\
                  '"type":"thumbnail","note":"Thumbnail"}'],
          isbn_number_a: ['1234567']
        )
      end

      it 'uses the Syndetics URL' do
        expect(helper.add_thumbnail(doc)).to(
          eq('<img class="coverImage" onerror="this.style.display = '\
             '&#39;none&#39;;" alt="cover image" src="https://syndetics.com/index.php?'\
             'client=trlnet&amp;isbn=1234567%2FSC.GIF" />')
        )
      end
    end

    context 'when the MARC provided URL is HTTPS' do
      let(:doc) do
        SolrDocument.new(
          id: 'DUKE012345678',
          url_a: ['{"href":"https://images.contentreserve.com/Img200.jpg",'\
                  '"type":"thumbnail","note":"Thumbnail"}']
        )
      end

      it 'uses the MARC supplied URL' do
        expect(helper.add_thumbnail(doc)).to(
          eq('<img class="coverImage" onerror="this.style.display = '\
             '&#39;none&#39;;" alt="cover image" '\
             'src="https://images.contentreserve.com/Img200.jpg" />')
        )
      end
    end
  end

  describe '#link_to_fulltext_url' do
    before { TrlnArgon::Engine.configuration.local_institution_code = 'duke' }

    context 'when url data includes text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: 'Law and contemporary problems, v. 63, no. 1-2' }
      end

      let(:result) do
        '<a class="link-type-fulltext link-restricted-duke" '\
        'target="_blank" '\
         'title="Law and contemporary problems, v. 63, no. 1-2" '\
         'data-toggle="tooltip" '\
         'href="http://www.law.duke.edu/journals/lcp/">'\
         '<i class="fa fa-external-link" aria-hidden="true">'\
         '</i>View Online</a>'
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_fulltext_url(url_hash)).to(eq(result))
      end
    end

    context 'when url data does not include text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: '' }
      end

      let(:result) do
        '<a class="link-type-fulltext link-restricted-duke" '\
        'target="_blank" '\
        'title="View Online" data-toggle="tooltip" '\
        'href="http://www.law.duke.edu/journals/lcp/">'\
        '<i class="fa fa-external-link" '\
        'aria-hidden="true"></i>View Online</a>'
      end

      it 'creates a link using the default translation' do
        expect(helper.link_to_fulltext_url(url_hash)).to(eq(result))
      end
    end
  end

  describe '#link_to_finding_aid' do
    context 'when url data includes text' do
      let(:url_hash) do
        { href: 'https://library.duke.edu/rubenstein/findingaids/ualacyc/',
          type: 'findingaid',
          text: 'Collection Guide for Collection' }
      end

      let(:result) do
        '<a class="link-type-findingaid" '\
        'target="_blank" '\
        'href="https://library.duke.edu/rubenstein/findingaids/ualacyc/">'\
        '<i class="fa fa-archive" aria-hidden="true"></i>'\
        'Collection Guide</a>'
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_finding_aid(url_hash)).to(eq(result))
      end
    end

    context 'when url data does not include text' do
      let(:url_hash) do
        { href: 'https://library.duke.edu/rubenstein/findingaids/ualacyc/',
          type: 'findingaid',
          text: '' }
      end

      let(:result) do
        '<a class="link-type-findingaid" '\
        'target="_blank" '\
        'href="https://library.duke.edu/rubenstein/findingaids/ualacyc/">'\
        '<i class="fa fa-archive" aria-hidden="true"></i>'\
        'Collection Guide</a>'
      end

      it 'creates a link using the default translation' do
        expect(helper.link_to_finding_aid(url_hash)).to(eq(result))
      end
    end
  end

  describe '#open_access_link_text' do
    context 'when url data includes text' do
      let(:url_hash) do
        { href: 'https://some-government-thing.gov/peanut-butter',
          type: 'fulltext',
          text: 'Some open access thing',
          restricted: 'false' }
      end

      it 'uses the supplied link text' do
        expect(helper.open_access_link_text(url_hash)).to(
          eq('Some open access thing')
        )
      end
    end

    context 'when url data does not include text' do
      let(:url_hash) do
        { href: 'https://some-government-thing.gov/peanut-butter',
          type: 'fulltext',
          restricted: 'false' }
      end

      it 'uses the default instead of the supplied link text' do
        expect(helper.open_access_link_text(url_hash)).to(eq('View Online'))
      end
    end
  end

  describe '#display_items?' do
    context 'when the document has only online items' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE012345678',
          items_a: ['{"loc_b":"LAW","loc_n":"LINRE","cn_scheme":" ",'\
                    '"call_no":"http://www.digital-law.net/IJCLP/index.html",'\
                    '"type":"ITNET","status":"Available"}']
        )
      end
      let(:options) { { document: document } }

      it 'returns false' do
        expect(helper.display_items?(options)).to be false
      end
    end

    context 'when the document has at least one physical item' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE012345678',
          items_a: ['{"loc_b":"PERKN","loc_n":"PK7","cn_scheme":"LC",'\
                    '"call_no":"DS113 .J57 2019","type":"BOOK",'\
                    '"item_id":"D05305040H","status":"On Hold"}']
        )
      end
      let(:options) { { document: document } }

      it 'returns true' do
        expect(helper.display_items?(options)).to be true
      end
    end
  end

  describe '#suppress_item?' do
    context 'when there are no items' do
      let(:loc_b) { '' }
      let(:loc_n) { '' }
      let(:item_data) { { 'items' => [] } }
      let(:options) do
        { loc_b: loc_b,
          loc_n: loc_n,
          item_data: item_data }
      end

      it 'returns true' do
        expect(helper.suppress_item?(options)).to be true
      end
    end

    context 'when the item is for an online location' do
      let(:loc_b) { 'LAW' }
      let(:loc_n) { 'LINRE' }
      let(:item_data) do
        { 'items' => ['{"loc_b":"PERKN","loc_n":"PK7","cn_scheme":"LC",'\
                      '"call_no":"DS113 .J57 2019","type":"BOOK",'\
                      '"item_id":"D05305040H","status":"On Hold"}'] }
      end
      let(:options) do
        { loc_b: loc_b,
          loc_n: loc_n,
          item_data: item_data }
      end

      it 'returns true' do
        expect(helper.suppress_item?(options)).to be true
      end
    end

    context 'when the item is for a physical location' do
      let(:loc_b) { 'PERKN' }
      let(:loc_n) { 'PK7' }
      let(:item_data) do
        { 'items' => ['{"loc_b":"PERKN","loc_n":"PK7","cn_scheme":"LC",'\
                      '"call_no":"DS113 .J57 2019","type":"BOOK",'\
                      '"item_id":"D05305040H","status":"On Hold"}'] }
      end
      let(:options) do
        { loc_b: loc_b,
          loc_n: loc_n,
          item_data: item_data }
      end

      it 'returns false' do
        expect(helper.suppress_item?(options)).to be false
      end
    end
  end

  describe 'physical_items?' do
    context 'when record does not have any physical items' do
      let(:document) do
        SolrDocument.new(
          YAML.safe_load(file_fixture('documents/DUKE006162724.yml').read)
        )
      end

      it 'returns false' do
        expect(physical_items?(document: document)).to be false
      end
    end

    context 'when record has physical items' do
      let(:document) do
        SolrDocument.new(
          YAML.safe_load(file_fixture('documents/DUKE004093564.yml').read)
        )
      end

      it 'returns true' do
        expect(physical_items?(document: document)).to be true
      end
    end
  end

  describe 'no_items?' do
    context 'when holding entry has no items' do
      let(:holdings) do
        YAML.safe_load(
          file_fixture('holdings/no_items_with_holdings_has_summary.yml').read
        )
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns false' do
        expect(no_items?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be true
        )
      end
    end

    context 'when holdings entry has items' do
      let(:holdings) do
        YAML.safe_load(
          file_fixture('holdings/items_with_holdings_no_summary.yml').read
        )
      end
      let(:loc_b) { holdings.keys.first }
      let(:loc_n) { holdings[loc_b].keys.first }
      let(:item_data) do
        holdings[loc_b][loc_n]
      end

      it 'returns false' do
        expect(no_items?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)).to(
          be false
        )
      end
    end
  end
end
