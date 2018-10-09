# frozen_string_literal: true

require 'dul_argon_skin/version'

module DulArgonSkin
  autoload :Configurable, 'dul_argon_skin/configurable'
  include DulArgonSkin::Configurable
end
