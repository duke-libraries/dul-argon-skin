# frozen_string_literal: true

require 'rails_helper'

describe SearchBuilder do
  subject { search_builder_class.new(processor_chain) }

  let(:search_builder_class) do
    Class.new(described_class)
  end

  let(:processor_chain) { [] }

  describe '#processor_chain' do
    let(:sb) { search_builder_class.new(CatalogController.new) }

    it 'adds the add_call_number_query_to_solr to the processor chain' do
      expect(sb.processor_chain).to include(:add_call_number_query_to_solr)
    end
  end
end
