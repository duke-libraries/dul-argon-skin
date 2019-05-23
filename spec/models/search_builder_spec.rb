# frozen_string_literal: true

require 'rails_helper'

describe SearchBuilder do
  subject { search_builder_class.new(processor_chain) }

  let(:search_builder_class) do
    Class.new(described_class)
  end

  let(:solr_parameters) { Blacklight::Solr::Request.new }
  let(:processor_chain) { [] }

  describe '#add_call_number_query_to_solr' do
    before do
      builder_with_params.add_call_number_query_to_solr(solr_parameters)
    end

    context 'with a basic call number' do
      let(:builder_with_params) do
        subject.with(q: 'PJ709 .G533', 'search_field' => 'call_number')
      end

      let(:expectation) do
        'lc_call_nos_normed_a:/PJ.0709.G533(\\..*|-.*)*/ OR '\
        'shelfkey:/lc:PJ.0709.G533(\\..*|-.*)*/ OR '\
        '_query_:"{!edismax qf=shelf_numbers_tp pf= pf3= pf2=}'\
        '(PJ709 .G533)"'
      end

      it 'assembles the call number query' do
        expect(solr_parameters[:q]).to(
          eq(expectation)
        )
      end

      it 'sets the defType to lucene' do
        expect(solr_parameters[:defType]).to eq('lucene')
      end
    end

    context 'with a call number that includes volume or copy info' do
      let(:builder_with_params) do
        subject.with(q: 'DD207.5 .M26 1975 Bd.2 c.1',
                     'search_field' => 'call_number')
      end

      let(:expectation) do
        'lc_call_nos_normed_a:/DD.02075.M26.1975(\\..*|-.*)*/ OR '\
        'shelfkey:/lc:DD.02075.M26.1975(\\..*|-.*)*/ OR '\
        '_query_:"{!edismax qf=shelf_numbers_tp pf= pf3= pf2=}'\
        '(DD207.5 .M26 1975 Bd.2 c.1)"'
      end

      it 'assembles the call number query without volume/copy info' do
        expect(solr_parameters[:q]).to(
          eq(expectation)
        )
      end
    end
  end

  describe '#processor_chain' do
    let(:sb) { search_builder_class.new(CatalogController.new) }

    it 'adds the add_call_number_query_to_solr to the processor chain' do
      expect(sb.processor_chain).to include(:add_call_number_query_to_solr)
    end
  end
end
