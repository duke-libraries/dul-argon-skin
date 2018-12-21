# frozen_string_literal: true

require 'dul_link_helper'

module TrlnArgonHelper
  include TrlnArgon::ViewHelpers::TrlnArgonHelper
  include DulLinkHelper

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

  def display_items?(options = {})
    return unless options.fetch(:document, nil)
    doc = options.fetch(:document, nil)
    holding_keys = doc.holdings.keys
    (holding_keys - DulArgonSkin.online_loc_b_codes.concat(['', nil])).any? &&
      online_items?(doc)
  end

  def suppress_item?(options = {})
    loc_b = options.fetch(:loc_b, '')
    loc_n = options.fetch(:loc_n, '')
    item_data = options.fetch(:item_data, {})

    DulArgonSkin.online_loc_b_codes.include?(loc_b) ||
      loc_b.blank? ||
      item_data.fetch('items', []).empty? ||
      DulArgonSkin.online_loc_n_codes.include?(loc_n)
  end

  def online_items?(doc)
    ((doc.fetch(TrlnArgon::Fields::ITEMS, [])
         .map { |i| JSON.parse(i) }
         .map { |ji| ji['loc_n'] }) - DulArgonSkin.online_loc_n_codes).any?
  end
end
