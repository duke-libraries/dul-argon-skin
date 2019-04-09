# frozen_string_literal: true

require 'rails_helper'

describe SearchBuilder do
  subject { search_builder_class.new(processor_chain) }

  let(:search_builder_class) do
    Class.new(described_class)
  end

  let(:solr_parameters) { Blacklight::Solr::Request.new }
  let(:processor_chain) { [] }

  describe '#add_shelfkey_query_to_solr' do
    before do
      builder_with_params.add_shelfkey_query_to_solr(solr_parameters)
    end

    context 'with a basic call number' do
      let(:builder_with_params) do
        subject.with(q: 'PJ709 .G533', 'search_field' => 'shelfkey')
      end

      it 'assembles the shelfkey query' do
        expect(solr_parameters[:q]).to(
          eq('shelfkey:/lc:PJ.0709.G533(\\..*|-.*)*/')
        )
      end

      it 'sets the defType to lucene' do
        expect(solr_parameters[:defType]).to eq('lucene')
      end
    end

    context 'with a call number that includes volume or copy info' do
      let(:builder_with_params) do
        subject.with(q: 'DD207.5 .M26 1975 Bd.2 c.1',
                     'search_field' => 'shelfkey')
      end

      it 'assembles the shelfkey query without volume/copy info' do
        expect(solr_parameters[:q]).to(
          eq('shelfkey:/lc:DD.02075.M26.1975(\\..*|-.*)*/')
        )
      end
    end
  end

  describe '#processor_chain' do
    let(:sb) { search_builder_class.new(CatalogController.new) }

    it 'adds the add_shelfkey_query_to_solr to the processor chain' do
      expect(sb.processor_chain).to include(:add_shelfkey_query_to_solr)
    end
  end
end
