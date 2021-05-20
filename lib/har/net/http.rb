# frozen_string_literal: true

require "net/http"
require_relative "http/version"

module Har
  module Net
    module HTTP
      class << self
        attr_accessor :har
      end
    end
  end
end

module Net
  # Reopen and monkey-patch the request method to capture traffic
  class HTTP
    alias original_request request

    def request(req, body = nil, &block)
      start_time = Time.now
      res = original_request(req, body, &block)
      end_time = Time.now
      duration = ((end_time.to_f - start_time.to_f) * 1000).round

      har_entry = {
        # https://gist.github.com/dstagner/193207fed46acf5b5bae
        startedDateTime: start_time.round(10).iso8601(6),
        time: duration,
        request: {
          method: req.method,
          url: req.uri.to_s,
          httpVersion: "HTTP/1.1",
          cookies: [],
          headers: req.to_hash.map { |name, value| { name: name, value: value, comment: "" } },
          queryString: [],
          headersSize: -1,
          bodySize: -1
        },
        response: {
          status: res.code,
          statusText: res.message,
          httpVersion: res.http_version,
          cookies: [],
          headers: [],
          content: {},
          redirectURL: "",
          headersSize: 160,
          bodySize: 850,
          comment: ""
        },
        cache: {},  # Not applicable to server-side logging.
        timings: {
          send: 0,  # Mandatory, but not applicable to server-side logging.
          wait: duration,
          receive: 0  # Mandatory, but not applicable to server-side logging.
        }
      }
      har = ::Har::Net::HTTP.har ||= {
        log: {
          version: "1.2",
          creator: {
            name: "har-net-http",
            version: ::Har::Net::HTTP::VERSION,
            comment: ""
          },
          browser: {
            name: RUBY_ENGINE,
            version: RUBY_VERSION,
            comment: ""
          },
          pages: [],
          entries: [],
          comment: ""
        }
      }
      har[:log][:entries] << har_entry

      res
    end
  end
end
