# frozen_string_literal: true

# Test job to verify Sidekiq is working
class TestJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Rails.logger.info 'Job ejecutado!'
  end
end
