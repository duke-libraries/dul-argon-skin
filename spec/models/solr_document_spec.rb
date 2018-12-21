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
          access_type_a: '["At the Library","Online"]',
          items_a: ['{"loc_b":"PERKN","loc_n":"PK7","cn_scheme":"LC",'\
                    '"call_no":"DS113 .J57 2019","type":"BOOK",'\
                    '"item_id":"D05305040H","status":"On Hold"}']
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

    context 'when the item belongs to Duke and includes an online location' do
      let(:solr_document) do
        described_class.new(
          id: 'DUKE012345678',
          items_a: ['{"loc_b":"LAW","loc_n":"LINRE","cn_scheme":" ",'\
                    '"call_no":"http://www.digital-law.net/IJCLP/index.html",'\
                    '"type":"ITNET","status":"Available"}']
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

  describe 'trln_requestable?' do
    context 'when item is at partner institution and at the library' do
      let(:solr_document) do
        described_class.new(
          id: 'UNC012345678',
          access_type_a: '["At the Library","Online"]',
          items_a: ['{"item_id":"i2065349","loc_b":"trln","loc_n":"trln",'\
                    '"status":"Available","cn_scheme":"LC",'\
                    '"call_no":"PN1998.A2 L328","vol":"v.1"}']
        )
      end

      before do
        allow(solr_document).to receive(:record_owner).and_return('unc')
      end

      it 'is requestable' do
        expect(solr_document.trln_requestable?).to be true
      end
    end

    context 'when item is at partner institution, but online-only' do
      let(:solr_document) do
        described_class.new(
          id: 'UNC012345678',
          access_type_a: '["Online"]'
        )
      end

      before do
        allow(solr_document).to receive(:record_owner).and_return('unc')
      end

      it 'is not requestable' do
        expect(solr_document.trln_requestable?).to be false
      end
    end
  end

  describe '#rubenstein_item?' do
    context 'when the record describes a rubenstein item' do
      let(:solr_document) do
        described_class.new(
          id: 'DUKE000117990',
          items_a: ['{"loc_b":"SCL","loc_n":"PRSBO","cn_scheme":"LC",'\
                    '"call_no":"PR4652 .W4 1919",'\
                    '"copy_no":"c.1","type":"BOOK","item_id":"D99003131Q",'\
                    '"status":"Available"}'],
          holdings_a: ['{"loc_b":"SCL","loc_n":"PRSBO",'\
                       '"call_no":"PR4652 .W4 1919"}']
        )
      end

      it 'is a rubenstein item' do
        expect(solr_document.rubenstein_record?).to be true
      end
    end

    context 'when the record describes items not from rubenstein' do
      let(:solr_document) do
        described_class.new(
          id: 'DUKE004531378',
          items_a: ['{"loc_b":"PERKN","loc_n":"PK","cn_scheme":"LC",'\
                    '"call_no":"PS151 .H46 2010","type":"BOOK",'\
                    '"item_id":"D04283757-","status":"Available"}'],
          holdings_a: ['{"loc_b":"PERKN","loc_n":"PK",'\
                       '"call_no":"PS151 .H46 2010"}']
        )
      end

      it 'is NOT a rubenstein item' do
        expect(solr_document.rubenstein_record?).to be false
      end
    end

    describe 'illiad_request_url_default' do
      before do
        allow(DulArgonSkin).to receive(:illiad_dul_base_url)
          .and_return(
            'https://duke-illiad-oclc-org.proxy.lib.duke.edu/illiad'\
            '/NDD/illiad.dll'
          )

        allow(solr_document).to receive(:illiad_request_params)\
          .and_return(
            'LoanAuthor=Art+Chansky&LoanTitle=Blue+blood'\
            '&Value=GenericRequestTRLNLoan&genre=TRLNbook'
          )
      end

      let(:solr_document) do
        described_class.new(
          id: 'DUKE012345678'
        )
      end

      it 'returns the full URL to request the item from TRLN at DUL' do
        expect(solr_document.illiad_request_url_default).to eq(
          'https://duke-illiad-oclc-org.proxy.lib.duke.edu/illiad/'\
          'NDD/illiad.dll?LoanAuthor=Art+Chansky&LoanTitle=Blue+blood'\
          '&Value=GenericRequestTRLNLoan&genre=TRLNbook'
        )
      end
    end

    describe 'illiad_request_params' do
      let(:solr_document) do
        described_class.new(
          id: 'DUKE003485622'
        )
      end

      before do
        allow(solr_document).to receive(:illiad_request_params_fixed)\
          .and_return(
            'Value': 'GenericRequestTRLNLoan',
            'genre': 'TRLNbook'
          )
        allow(solr_document).to receive(:illiad_request_params_variable)\
          .and_return(
            'Location': 'https://find.library.duke.edu/trln/DUKE003485622',
            'LoanTitle': 'Blue blood',
            'ESPNumber': '505249141',
            'ISSN': '9780134276717',
            'LoanEdition': '1st ed.',
            'LoanPublisher': 'Boston',
            'LoanAuthor': 'Art Chansky'
          )
      end

      # rubocop:disable RSpec/ExampleLength
      it 'returns the combined parameters as URL query string' do
        expect(solr_document.illiad_request_params).to eq(
          'ESPNumber=505249141&ISSN=9780134276717'\
          '&LoanAuthor=Art+Chansky&LoanEdition=1st+ed.&LoanPublisher=Boston'\
          '&LoanTitle=Blue+blood'\
          '&Location=https%3A%2F%2Ffind.library.duke.edu%2F'\
          'trln%2FDUKE003485622'\
          '&Value=GenericRequestTRLNLoan&genre=TRLNbook'
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end
end
