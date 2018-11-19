# frozen_string_literal: true

module TrlnArgonHelper
  include TrlnArgon::ViewHelpers::TrlnArgonHelper

  def link_to_fulltext_url(url_hash)
    return if url_hash[:href].blank?
    link_to_others(url_hash)
  end

  def link_to_finding_aid(url_hash)
    link_icon = '<i class="fa fa-archive" aria-hidden="true"></i>'
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]}",
            target: '_blank') do
              link_icon.html_safe + t('trln_argon.links.finding_aid')
            end
  end

  def link_to_others(url_hash)
    inst = TrlnArgon::Engine.configuration.local_institution_code
    link_icon = '<i class="fa fa-external-link" aria-hidden="true"></i>'
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-restricted-#{inst}",
            target: '_blank', title: fulltext_link_text(url_hash),
            data: { toggle: 'tooltip', placement: 'right' }) do
              link_icon.html_safe + t('trln_argon.links.online_access')
            end
  end
end
