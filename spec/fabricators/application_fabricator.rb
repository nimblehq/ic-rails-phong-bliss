# frozen_string_literal: true

Fabricator(:application, from: Doorkeeper::Application) do
  name ['iOS client', 'Android client'].sample
end
