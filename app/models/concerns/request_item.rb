# frozen_string_literal: true

# Module for SolrDocument adding methods related to integration
# with DUL Requests System (requests.library.duke.edu)

module RequestItem
  extend ActiveSupport::Concern

  def request_item_url
    base = DulArgonSkin.request_base_url
    [base, 'item', stripped_id(id)].join('/')
  end

  def duke_requestable?
    duke_owned? && physical_item?
  end

  private

  def stripped_id(id)
    id.sub('DUKE', '')
  end

  def duke_owned?
    record_owner == 'duke'
  end

  def physical_item?
    fetch('access_type_a', []).include?('At the Library')
  end
end
