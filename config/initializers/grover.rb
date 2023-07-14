# frozen_string_literal: true

Grover.configure do |config|
  config.options = {
    launch_args: %w[--no-sandbox --disable-setuid-sandbox]
  }
end
