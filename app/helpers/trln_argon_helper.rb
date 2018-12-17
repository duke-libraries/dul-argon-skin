# frozen_string_literal: true

module TrlnArgonHelper
  include TrlnArgon::ViewHelpers::TrlnArgonHelper

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

  include TrlnArgon::ViewHelpers::ItemsSectionHelper

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
end
