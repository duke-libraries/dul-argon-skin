# frozen_string_literal: true

module DulLinkHelper
  def link_to_finding_aid(url_hash)
    link_icon = '<i class="fa fa-archive" aria-hidden="true"></i>'
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]}",
            target: '_blank') do
              link_icon.html_safe + t('trln_argon.links.finding_aid')
            end
  end

  def link_to_fulltext_url(url_hash, options = {})
    return if url_hash[:href].blank?
    inst = TrlnArgon::Engine.configuration.local_institution_code
    link_icon = '<i class="fa fa-external-link" aria-hidden="true"></i>'
    if options[:link_type] == 'multiple'
      fulltext_without_tooltip(url_hash, link_icon, inst)
    else
      fulltext_with_tooltip(url_hash, link_icon, inst)
    end
  end

  def fulltext_with_tooltip(url_hash, link_icon, inst)
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-restricted-#{inst}",
            target: '_blank', title: fulltext_link_text(url_hash),
            data: { toggle: 'tooltip' }) do
              link_icon.html_safe + t('trln_argon.links.online_access')
            end
  end

  def fulltext_without_tooltip(url_hash, link_icon, inst)
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-restricted-#{inst}",
            target: '_blank') do
              link_icon.html_safe + fulltext_link_text(url_hash)
            end
  end

  def link_to_expanded_fulltext_url(url_hash, inst, options = {})
    return if url_hash[:href].blank?
    if options[:link_type] == 'multiple'
      expanded_without_tooltip(url_hash, inst)
    else
      expanded_with_tooltip(url_hash, inst)
    end
  end

  def expanded_with_tooltip(url_hash, inst)
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-restricted-#{inst}",
            target: '_blank', title: fulltext_link_text(url_hash),
            data: { toggle: 'tooltip' }) do
      '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe +
        expanded_fulltext_link_text(inst)
    end
  end

  def expanded_without_tooltip(url_hash, inst)
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-restricted-#{inst}",
            target: '_blank') do
      '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe +
        fulltext_link_text(url_hash)
    end
  end

  def fulltext_link_text(url_hash)
    if url_hash[:note].present? && url_hash[:text].present?
      "#{url_hash[:text]} — #{url_hash[:note]}"
    elsif url_hash[:note].present?
      url_hash[:note]
    elsif url_hash[:text].present?
      url_hash[:text]
    else
      I18n.t('trln_argon.links.online_access')
    end
  end

  def open_access_link_text(_url_hash)
    I18n.t('trln_argon.links.open_access')
  end

  def expanded_link_to_open_access(url_hash, options = {})
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-open-access",
            target: '_blank') do
      '<i class="fa fa-external-link" aria-hidden="true"></i>'.html_safe +
        expanded_open_access_link_text(url_hash, options)
    end
  end

  def expanded_open_access_link_text(url_hash, options = {})
    openaccess_text = I18n.t('trln_argon.links.open_access')
    if options[:link_type] == 'multiple'
      return url_hash[:text] if url_hash[:text].present?
      return openaccess_text
    end
    return openaccess_text if options[:link_type] != 'multiple'
  end
end
