# frozen_string_literal: true

require 'rails_helper'

describe ReportMissingItemHelper do
  describe '#link_to_report_missing_item' do
    context 'when it is a Duke physical record' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE0123456789',
          title_main: 'The bond : a novel',
          names_a: ['{"name":"Kirk, Robin","rel":"author"}'],
          owner_a: ['duke'],
          access_type_a: '["At the Library","Online"]',
          items_a: ['{"loc_b":"PERKN","loc_n":"PK7","cn_scheme":"LC",'\
                    '"call_no":"DS113 .J57 2019","type":"BOOK",'\
                    '"item_id":"D05305040H","status":"On Hold"}']
        )
      end
      let(:options) do
        { document: document }
      end
      let(:response) do
        '<a target="_blank" '\
        'href="https://duke.qualtrics.com/jfe/form/SV_71J91hwAk1B5YkR/'\
        '?BTITLE=The%20bond%20%3A%20a%20novel&amp;'\
        'AUTHOR=Kirk%2C%20Robin&amp;Q_JFE=qdg">'\
        'Report missing item</a>'
      end

      it 'generates link to report a missing item' do
        expect(helper.link_to_report_missing_item(options)).to(
          eq(response)
        )
      end
    end

    context 'when it is a Duke online record' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE0123456789',
          owner_a: ['duke'],
          items_a: ['{"loc_b":"LAW","loc_n":"LINRE","cn_scheme":" ",'\
                    '"call_no":"http://www.digital-law.net/IJCLP/index.html",'\
                    '"type":"ITNET","status":"Available"}']
        )
      end
      let(:options) do
        { document: document }
      end

      it 'does not generate a link' do
        expect(helper.link_to_report_missing_item(options)).to be_nil
      end
    end

    context 'when it is a UNC record with a physical item' do
      let(:document) do
        SolrDocument.new(
          id: 'UNC0123456789',
          owner_a: ['unc'],
          access_type_a: '["At the Library","Online"]',
          items_a: ['{"item_id":"i2065349","loc_b":"trln","loc_n":"trln",'\
                    '"status":"Available","cn_scheme":"LC",'\
                    '"call_no":"PN1998.A2 L328","vol":"v.1"}']
        )
      end
      let(:options) do
        { document: document }
      end

      it 'does not generate a link' do
        expect(helper.link_to_report_missing_item(options)).to be_nil
      end
    end
  end
end
