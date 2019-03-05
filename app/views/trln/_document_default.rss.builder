# frozen_string_literal: true

# NOTE: temporary patch; remove when this issue is
# fixed in the TRLN Argon engine.
xml.item do
  xml.title(document.title_and_responsibility)
  xml.link(url_for_document(document))
end
