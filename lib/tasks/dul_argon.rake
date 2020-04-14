# frozen_string_literal: true

require 'csv'

namespace :dul_argon do
  namespace :hathitrust do
    desc 'Reload overlap file for emergency access ' \
         'to restricted HathiTrust material'
    # Expects a file with the following CSV format
    # oclc_number,bib_id,access
    # 74,DUKE000000008,allow
    # 75,DUKE000000009,deny
    task :reload_overlaps, [:file_path] => [:environment] do |_, args|
      return unless args.fetch(:file_path, nil)
      HathitrustOverlap.delete_all
      CSV.foreach(args[:file_path], headers: true) do |row|
        HathitrustOverlap.create!(row.to_hash)
      end
    end
  end
end
