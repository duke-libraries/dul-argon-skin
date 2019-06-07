# frozen_string_literal: true

# Overrides TRLN Argon behavior

module SmsFieldMapping
  extend ActiveSupport::Concern

  def sms_field_mapping
    @sms_field_mapping ||= {
      title: proc do
               truncate(self[TrlnArgon::Fields::TITLE_MAIN].to_s, length: 50)
             end,
      location: proc { holdings_to_text },
      link_to_record: proc { link_to_record }
    }
  end
end
