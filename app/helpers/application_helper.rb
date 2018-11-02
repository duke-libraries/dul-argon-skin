# frozen_string_literal: true

module ApplicationHelper
  def git_branch_info
    `git rev-parse --abbrev-ref HEAD`
  end
end
