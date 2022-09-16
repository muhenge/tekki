# frozen_string_literal: true

$redis = Redis::Namespace.new('tekki', redis: Redis.new)
