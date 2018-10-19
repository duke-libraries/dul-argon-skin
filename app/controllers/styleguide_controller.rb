# frozen_string_literal: true

class StyleguideController < ApplicationController
  def show
    render 'styleguide/show', layout: 'blacklight'
  end
end
