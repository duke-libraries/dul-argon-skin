# frozen_string_literal: true

require 'rails_helper'

describe RequestDigitizationHelper do
  describe '#link_to_request_digitization' do
    context 'when it is an old book' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE000136160',
          local_id: 'DUKE000136160',
          title_main: 'The book; the story of printing & bookmaking',
          owner_a: ['duke'],
          publication_year_sort: '1943',
          resource_type_a: ['Book'],
          access_type_a: ['At the Library'],
          items_a: ['{"loc_b":"PERKN","loc_n":"PK","cn_scheme":"LC",'\
                    '"call_no":"Z4 .M15 1943","type":"BOOK",'\
                    '"item_id":"D03714484V","status":"Available"}']
        )
      end
      let(:options) do
        { document: document }
      end
      let(:response) do
        '<a target="_blank" '\
        'href="https://duke.qualtrics.com/jfe/form/SV_9MOS64T5GlJ5bY9'\
        '?Title=The%20book%3B%20the%20story%20of%20'\
        'printing%20%26%20bookmaking&amp;'\
        'Author=&amp;Published=1943&amp;'\
        'SystemID=000136160">'\
        '<i class="glyphicon glyphicon-duplicate" '\
        'aria-hidden="true"></i> '\
        'Digitization Request</a>'
      end

      it 'generates link to request digitization' do
        expect(helper.link_to_request_digitization(options)).to(
          eq(response)
        )
      end
    end

    context 'when it is an old book with a link' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE008746259',
          local_id: 'DUKE008746259',
          title_main: 'Jurgen; a comedy of justice',
          owner_a: ['duke'],
          publication_year_sort: '1922',
          resource_type_a: ['Book'],
          access_type_a: ['At the Library', 'Online'],
          items_a: ['{"loc_b":"PERKN","loc_n":"PK","cn_scheme":"LC",'\
                    '"call_no":"PZ3.C107 Ju3 1922","type":"BOOK",'\
                    '"item_id":"D05278727","status":"Available"}']
        )
      end
      let(:options) do
        { document: document }
      end
      let(:response) do
        '<a target="_blank" '\
        'href="https://duke.qualtrics.com/jfe/form/SV_9MOS64T5GlJ5bY9'\
        '?Title=Jurgen%3B%20a%20comedy%20of%20justice&amp;'\
        'Author=&amp;Published=1922&amp;'\
        'SystemID=008746259">'\
        '<i class="glyphicon glyphicon-duplicate" '\
        'aria-hidden="true"></i> '\
        'Digitization Request</a>'
      end

      it 'generates link to request digitization' do
        expect(helper.link_to_request_digitization(options)).to(
          eq(response)
        )
      end
    end

    context 'when it is a recent book' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE003074110',
          local_id: 'DUKE003074110',
          title_main: 'Dhalgren',
          owner_a: ['duke'],
          publication_year_sort: '1973',
          resource_type_a: ['Book'],
          access_type_a: ['At the Library'],
          items_a: ['{"loc_b":"PERKN","loc_n":"PK","cn_scheme":"LC",'\
                    '"call_no":"PS3554.E437 D48 2001","type":"BOOK",'\
                    '"item_id":"D01631528Q","status":"Available"}']
        )
      end
      let(:options) do
        { document: document }
      end

      it 'does not generate a link' do
        expect(helper.link_to_request_digitization(options)).to be_nil
      end
    end

    context 'when it is an old serial' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE000447283',
          local_id: 'DUKE000447283',
          title_main: 'Administration of relief abroad.',
          owner_a: ['duke'],
          publication_year_sort: '1943',
          resource_type_a: ['Journal, Magazine, or Periodical'],
          access_type_a: ['At the Library'],
          items_a: ['{"loc_b":"PERKN","loc_n":"PK","cn_scheme":"LC",'\
                    '"call_no":"D808 .A365",'\
                    '"item_id":"HANK-1675-00001","status":"Available"}']
        )
      end
      let(:options) do
        { document: document }
      end

      it 'does not generate a link' do
        expect(helper.link_to_request_digitization(options)).to be_nil
      end
    end

    context 'when it is an book at an excluded location' do
      let(:document) do
        SolrDocument.new(
          id: 'DUKE003593089',
          local_id: 'DUKE003593089',
          title_main: '100 meat-saving recipes',
          owner_a: ['duke'],
          publication_year_sort: '1943',
          resource_type_a: ['Journal, Magazine, or Periodical'],
          access_type_a: ['At the Library'],
          items_a: ['{"loc_b":"SCL","loc_n":"PRSBQ","cn_scheme":"LC",'\
                    '"call_no":"TX715 .R62 1943",'\
                    '"item_id":"D03022111A","status":"Available"}']
        )
      end
      let(:options) do
        { document: document }
      end

      it 'does not generate a link' do
        expect(helper.link_to_request_digitization(options)).to be_nil
      end
    end
  end
end
