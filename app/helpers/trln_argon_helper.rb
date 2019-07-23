# frozen_string_literal: true

module TrlnArgonHelper
  include TrlnArgon::ViewHelpers::TrlnArgonHelper

  def show_class
    'col-lg-9 col-md-9 col-sm-9 show-document'
  end

  def show_main_content_partials_class
    'col-md-12 show-main-content-partials'
  end

  def show_tools_class
    'col-md-12 show-tools'
  end

  def show_sub_header_class
    'show-sub-header'
  end

  def add_thumbnail(document, size: :small)
    return marc_thumbnail_tag(document) if document.thumbnail_urls.any? &&
                                           document.thumbnail_urls
                                                   .first
                                                   .fetch(:href, '')
                                                   .match(%r{https:\/\/})

    syndetics_thumbnail_tag(document, size)
  end

  # ItemsSectionHelper

  def call_number_wrapper_class(_options = {})
    'col-lg-7 col-sm-12 call-number-wrapper'
  end

  def holdings_summary_wrapper_class(_options = {})
    'col-lg-12 col-sm-12 summary-wrapper'
  end

  def status_wrapper_class(_options = {})
    'col-lg-5 col-sm-12'
  end

  def item_note_wrapper_class(options = {})
    if options.fetch(:action, false) == 'show' &&
       options.fetch(:item_length, 0) < 120
      'col-lg-6 col-sm-12'
    else
      'col-md-12'
    end
  end

  def online_only_items?(options = {})
    loc_b = options.fetch(:loc_b, '')
    loc_n = options.fetch(:loc_n, '')
    DulArgonSkin.online_loc_b_codes.include?(loc_b) ||
      DulArgonSkin.online_loc_n_codes.include?(loc_n)
  end

  # Used by DUL Argon to determine whether to show
  # "Staff View" link for records with any barcodes.
  def physical_items?(options = {})
    doc = options.fetch(:document, nil)
    return unless doc

    has_items = doc.holdings.map do |loc_b, loc_n_map|
      loc_n_map.reject do |loc_n, item_data|
        no_items?(loc_b: loc_b, loc_n: loc_n, item_data: item_data)
      end
    end
    has_items.flatten.reject(&:empty?).any?
  end

  def no_items?(options = {})
    loc_b = options.fetch(:loc_b, '')
    loc_n = options.fetch(:loc_n, '')
    item_data = options.fetch(:item_data, {})
    item_data.fetch('items').reject(&:empty?).none? ||
      online_only_items?(loc_b: loc_b, loc_n: loc_n)
  end

  # Link Helper

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

  def link_to_open_access(url_hash, options = {})
    return if url_hash[:href].blank?

    link_icon = '<i class="fa fa-external-link" aria-hidden="true"></i>'
    if options[:link_type] == 'multiple'
      open_access_without_tooltip(url_hash, link_icon)
    else
      open_access_with_tooltip(url_hash, link_icon)
    end
  end

  def open_access_with_tooltip(url_hash, link_icon)
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-open-access",
            target: '_blank', title: open_access_link_text(url_hash),
            data: { toggle: 'tooltip' }) do
              link_icon.html_safe + t('trln_argon.links.online_access')
            end
  end

  def open_access_without_tooltip(url_hash, link_icon)
    link_to(url_hash[:href],
            class: "link-type-#{url_hash[:type]} link-open-access",
            target: '_blank') do
              link_icon.html_safe + open_access_link_text(url_hash)
            end
  end

  def open_access_link_text(url_hash)
    if url_hash[:note].present? && url_hash[:text].present?
      "#{url_hash[:text]} — #{url_hash[:note]}"
    elsif url_hash[:note].present?
      url_hash[:note]
    elsif url_hash[:text].present?
      url_hash[:text]
    else
      I18n.t('trln_argon.links.open_access')
    end
  end

  def expanded_link_to_open_access(url_hash, options = {})
    link_to_open_access(url_hash, options)
  end
end
