# frozen_string_literal: true

require 'rails_helper'

describe TrlnArgonHelper do
  describe '#link_to_fulltext_url' do
    before { TrlnArgon::Engine.configuration.local_institution_code = 'duke' }

    context 'when url data includes text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: 'Law and contemporary problems, v. 63, no. 1-2' }
      end

      let(:result) do
        '<a class="link-type-fulltext link-restricted-duke" '\
        'target="_blank" '\
         'title="Law and contemporary problems, v. 63, no. 1-2" '\
         'data-toggle="tooltip" '\
         'href="http://www.law.duke.edu/journals/lcp/">'\
         '<i class="fa fa-external-link" aria-hidden="true">'\
         '</i>View Online</a>'
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_fulltext_url(url_hash)).to(eq(result))
      end
    end

    context 'when url data does not include text' do
      let(:url_hash) do
        { href: 'http://www.law.duke.edu/journals/lcp/',
          type: 'fulltext',
          text: '' }
      end

      let(:result) do
        '<a class="link-type-fulltext link-restricted-duke" '\
        'target="_blank" '\
        'title="View Online" data-toggle="tooltip" '\
        'href="http://www.law.duke.edu/journals/lcp/">'\
        '<i class="fa fa-external-link" '\
        'aria-hidden="true"></i>View Online</a>'
      end

      it 'creates a link using the default translation' do
        expect(helper.link_to_fulltext_url(url_hash)).to(eq(result))
      end
    end
  end

  describe '#link_to_finding_aid' do
    context 'when url data includes text' do
      let(:url_hash) do
        { href: 'https://library.duke.edu/rubenstein/findingaids/ualacyc/',
          type: 'findingaid',
          text: 'Collection Guide for Collection' }
      end

      let(:result) do
        '<a class="link-type-findingaid" '\
        'target="_blank" '\
        'href="https://library.duke.edu/rubenstein/findingaids/ualacyc/">'\
        '<i class="fa fa-archive" aria-hidden="true"></i>'\
        'Collection Guide</a>'
      end

      it 'creates a link using the supplied text' do
        expect(helper.link_to_finding_aid(url_hash)).to(eq(result))
      end
    end

    context 'when url data does not include text' do
      let(:url_hash) do
        { href: 'https://library.duke.edu/rubenstein/findingaids/ualacyc/',
          type: 'findingaid',
          text: '' }
      end

      let(:result) do
        '<a class="link-type-findingaid" '\
        'target="_blank" '\
        'href="https://library.duke.edu/rubenstein/findingaids/ualacyc/">'\
        '<i class="fa fa-archive" aria-hidden="true"></i>'\
        'Collection Guide</a>'
      end

      it 'creates a link using the default translation' do
        expect(helper.link_to_finding_aid(url_hash)).to(eq(result))
      end
    end
  end
end
