# frozen_string_literal: true

class SolrDocument
  include SolrDocumentBehavior

  def rubenstein_record?
    holdings.key?('SCL')
  end
end
