module Rack
  class Attack
    ### README ###

    # In this class you can set the following variables to configure the blocklisting, whitelisting,
    # and throttling of the requests that the API receives:
    # limit: amount of request that a user can make in a period without being blocked for the rest of
    #        the period
    # period: period of time for the previous limit. When this period is reached, you can make n
    #         more requests, where n is the limit previously defined.
    # maxretry: amount of requests that a user can make in findtime without being blocked for the bantime
    # findtime: period of time for the previous maxretry.
    # bantime: period of time that a user is blocked if exceeds the maxretry in a findtime.
    # Be careful that the configuration for malicious users do not affect normal users  behaviour.

    ### Configure Cache ###

    # If you don't want to use Rails.cache (Rack::Attack's default), then
    # configure it here.
    #
    # Note: The store is only used for throttling (not blacklisting and
    # whitelisting). It must implement .increment and .write like
    # ActiveSupport::Cache::Store

    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    def self.rack_attack_enabled?
      return true if Rails.env.test?
      Rails.application.secrets.rack_attack_enabled.to_b
    end

    def self.max_requests_per_second
      Rails.application.secrets.rack_attack_max_requests_per_second
    end

    ### Rules ###
    if rack_attack_enabled?
      throttle('req/ip', limit: max_requests_per_second, period: 1.second) do |req|
        req.ip unless req.path.start_with?('/assets')
      end
    end

    # Exponential Backoff configuration for login
    #
    # Allows 20 requests in 8  seconds
    #        40 requests in 64 seconds
    #        ...
    #        100 requests in 0.38 days (~250 requests/day)
    # if rack_attack_enabled?
    #   (1..5).each do |level|
    #     throttle("logins/ip/#{level}", limit: (20 * level), period: (8 ** level).seconds) do |req|
    #       if req.path == my_login_path && req.post?
    #         req.ip
    #       end
    #     end
    #   end
    # end

    ### Custom Throttle Response ###

    # By default, Rack::Attack returns an HTTP 429 for throttled responses,
    # which is just fine.
    #
    # If you want to return 503 so that the attacker might be fooled into
    # believing that they've successfully broken your app (or you just want to
    # customize the response), then uncomment these lines.
    #
    # self.throttled_response = lambda do |_env|
    #   [503, {}, ['Server Error']] # status  # headers  # body
    # end

    self.throttled_responder = lambda do |env|
      now = Time.zone.now
      match_data = env['rack.attack.match_data']

      headers = {
        'X-RateLimit-Limit' => match_data[:limit].to_s,
        'X-RateLimit-Remaining' => '0',
        'X-RateLimit-Reset' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s
      }

      [429, headers, ["Throttled\n"]]
    end

    ### Custom Blocklist Response ###

    # By default, Rack::Attack returns an HTTP 403 for blocklisted responses,
    # which is just fine.
    #
    # If you want to return 503 so that the attacker might be fooled into
    # believing that they've successfully broken your app (or you just want to
    # customize the response), then uncomment these lines.
    #
    # self.blocklisted_response = lambda do |_env|
    #   [503, {}, ['Server Error']] # status  # headers  # body
    # end
  end
end
