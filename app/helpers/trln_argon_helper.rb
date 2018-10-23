# frozen_string_literal: true

module TrlnArgonHelper
  include TrlnArgon::ViewHelpers::TrlnArgonHelper

  def link_to_primary_url(url_hash)
    return if url_hash[:href].blank?
    if url_hash[:type] == 'findingaid'
      link_to_findingaid(url_hash)
    else
      link_to_others(url_hash)
    end
  end

  def link_to_findingaid(url_hash)
    link_icon = '<i class="fa fa-archive" aria-hidden="true"></i>'
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]}",
            target: '_blank') do
              link_icon.html_safe + primary_url_text(url_hash)
            end
  end

  def link_to_others(url_hash)
    link_icon = '<i class="fa fa-external-link" aria-hidden="true"></i>'
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]}",
            target: '_blank', title: primary_url_text(url_hash),
            data: { toggle: 'tooltip', placement: 'right' }) do
              link_icon.html_safe + t('trln_argon.links.online_access')
            end
  end
end
