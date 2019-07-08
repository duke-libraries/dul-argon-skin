# frozen_string_literal: true

module ReportMissingItemHelper
  def link_to_report_missing_item(options = {})
    document = options.fetch(:document, nil)
    return unless show_report_missing_item_link?(document)

    link_to '<i class="glyphicon glyphicon-exclamation-sign" '\
            'aria-hidden="true"></i> '\
            "#{I18n.t('trln_argon.show.report_missing')}".html_safe,
            report_missing_item_url(document),
            target: '_blank'
  end

  private

  def report_missing_item_params(document)
    { 'BTITLE' => document.fetch(TrlnArgon::Fields::TITLE_MAIN,
                                 'title unknown'),
      'AUTHOR' => document.names.first.to_h.fetch(:name, ''),
      'Q_JFE' => 'qdg' }
  end

  def report_missing_item_url(document)
    report_missing_item_url_template.expand(
      'query' => report_missing_item_params(document)
    ).to_s
  end

  def report_missing_item_url_template
    Addressable::Template.new(DulArgonSkin.report_missing_item_url)
  end

  def show_report_missing_item_link?(document)
    DulArgonSkin.report_missing_item_url.present? &&
      document.present? &&
      document.record_owner == 'duke' &&
      display_items?(document: document)
  end
end
