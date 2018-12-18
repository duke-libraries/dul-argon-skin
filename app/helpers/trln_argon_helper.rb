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
end
