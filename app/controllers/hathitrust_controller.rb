# frozen_string_literal: true

class HathitrustController < ApplicationController
  include TrlnArgon::HathitrustControllerBehavior

  def show_etas
    render json: etas_links_grouped_by_oclc_number
  end

  private

  def etas_links_grouped_by_oclc_number
    hathitrust_response_hash.map do |key, value|
      full_text_url = hathitrust_fulltext_url(value)
      next unless etas_fulltext_item?(value)
      [key.delete(':'), render_etas_partial_to_string(full_text_url)]
    end.compact.to_h.to_json
  end

  def render_etas_partial_to_string(full_text_url)
    render_to_string('hathitrust/etas',
                     locals: { etas_argon_url_hash:
                                 etas_argon_url_hash(full_text_url) },
                     layout: false)
  end

  def etas_argon_url_hash(full_text_url)
    { href: "#{full_text_url}?signon=swle:urn:mace:incommon:duke.edu",
      type: 'fulltext',
      text: I18n.t('trln_argon.links.hathitrust') }
  end

  def etas_fulltext_item?(value)
    value.fetch('items', [])
         .select { |i| i.fetch('usRightsString') == 'Limited (search-only)' }
         .any?
  end
end
