# frozen_string_literal: true

module CallNumberSearchBuilder
  extend ActiveSupport::Concern

  def add_call_number_query_to_solr(solr_parameters)
    return unless call_number_query_present?

    solr_parameters[:defType] = 'lucene'
    solr_parameters[:q] = call_number_queries
  end

  private

  def call_number_query_present?
    blacklight_params.key?('search_field') &&
      blacklight_params['search_field'] == 'call_number' &&
      blacklight_params[:q].present? &&
      blacklight_params[:q].respond_to?(:to_str)
  end

  def call_number_queries
    [lc_callno_query,
     shelfkey_query,
     acc_num_query,
     acc_num_variant_query].compact.join(' OR ')
  end

  def normalized_lc_callno
    @normalized_lc_callno ||= Lcsort.normalize(blacklight_params[:q].to_s) ||
                              blacklight_params[:q].to_s
  end

  def acc_num_query
    "_query_:\"{!edismax qf=#{TrlnArgon::Fields::SHELF_NUMBERS} pf= pf3= pf2=}"\
    "(#{blacklight_params[:q]})\""
  end

  def acc_num_variant_query
    return unless acc_num_variant
    "_query_:\"{!edismax qf=#{TrlnArgon::Fields::SHELF_NUMBERS} pf= pf3= pf2=}"\
    "(#{acc_num_variant})\""
  end

  # Convert CD123456 to CD 123456
  # OR
  # Convert CD 123456 to CD123456
  def acc_num_variant
    if query_includes_acc_num_without_space?
      blacklight_params[:q].to_s.gsub(acc_num_without_space_regex, '\1 \2')
    elsif query_includes_acc_numb_with_space?
      blacklight_params[:q].to_s.gsub(acc_num_with_space_regex, '\1\3')
    end
  end

  # Generate fielded regex query for Solr.
  # Regex fussiness at the end is to force the last
  # segment to match completely.
  def lc_callno_query
    "#{TrlnArgon::Fields::LC_CALL_NOS_NORMED}:"\
    "/#{normalized_lc_callno.split('--').first}(\\..*|-.*)*/"
  end

  # NOTE: This should be removed eventually, but is needed so
  #       that call no searching will continue to work until
  #       all records are updated to have the lc_call_nos_normed_a field
  def shelfkey_query
    "#{TrlnArgon::Fields::SHELFKEY}:"\
    "/lc:#{normalized_lc_callno.split('--').first}(\\..*|-.*)*/"
  end

  def query_includes_acc_num_without_space?
    blacklight_params[:q].to_s.match?(acc_num_without_space_regex)
  end

  def query_includes_acc_numb_with_space?
    blacklight_params[:q].to_s.match?(acc_num_with_space_regex)
  end

  # Look for common accession number patterns without
  # a space between the prefix and suffix, e.g. CD123456
  def acc_num_without_space_regex
    /^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)([A-Z\d]+)/i
  end

  # Look for common accession number patterns with
  # a space between the prefix and suffix, e.g. CD 123456
  def acc_num_with_space_regex
    /^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)(\s+)([A-Z\d]+)/i
  end
end
