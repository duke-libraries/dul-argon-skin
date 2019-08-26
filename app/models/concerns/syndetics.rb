# frozen_string_literal: true

# Overrides TRLN Argon behavior
module Syndetics
  # For all records except Rubenstein favor
  # the Sydentics supplied summary.
  def syndetics_or_marc_summary
    @syndetics_or_marc_summary ||=
      if !rubenstein_record?
        syndetics_summary || marc_summary
      else
        marc_summary || syndetics_summary
      end
  end

  # For all records except Rubenstein favor
  # the Sydentics supplied TOC.
  def syndetics_or_marc_toc
    @syndetics_or_marc_toc ||=
      if !rubenstein_record?
        syndetics_toc || marc_toc
      else
        marc_toc || syndetics_toc
      end
  end

  private

  def syndetics_summary
    syndetics_data && syndetics_data&.summary
  end

  def syndetics_toc
    syndetics_data && syndetics_data&.toc
  end
end
