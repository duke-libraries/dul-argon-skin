# frozen_string_literal: true

# IMPORTANT: Do not put methods here that are also needed
#            in the TRLN Scope. Shared SolrDocument methods
#            should go in:
#            app/models/concerns/solr_document_behavior.rb.
class SolrDocument
  include SolrDocumentBehavior
end
