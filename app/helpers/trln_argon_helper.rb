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

  def call_number_wrapper_class(options = {})
    if options.fetch(:action, false) == 'show'
      'col-lg-7 col-sm-12 call-number-wrapper'
    else
      'col-lg-7 col-sm-12 call-number-wrapper'
    end
  end

  def holdings_summary_wrapper_class(options = {})
    if options.fetch(:action, false) == 'show'
      'col-lg-12 col-sm-12 summary-wrapper'
    else
      'col-lg-12 col-sm-12 summary-wrapper'
    end
  end

  def status_wrapper_class(options = {})
    if options.fetch(:action, false) == 'show'
      'col-lg-5 col-sm-12'
    else
      'col-lg-5 col-sm-12'
    end
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
