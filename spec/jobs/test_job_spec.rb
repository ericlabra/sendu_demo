# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestJob do
  it 'ejecuta el job correctamente' do
    described_class.perform_async
    expect(described_class.jobs.size).to eq(1)
  end

  it 'imprime el mensaje Job ejecutado' do
    expect(Rails.logger).to receive(:info).with('Job ejecutado!')
    described_class.new.perform
  end
end
