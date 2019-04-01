# frozen_string_literal: true

class BookmarksController < CatalogController
  include Blacklight::Bookmarks
  include TrlnArgon::BookmarksControllerBehavior

  configure_blacklight do |config|
    config.index.collection_actions.delete(:rss_button)
    config.index.collection_actions.delete(:bookmarks_button)
  end
end
