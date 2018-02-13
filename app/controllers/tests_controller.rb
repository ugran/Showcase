class TestsController < ApplicationController
    require 'uri'
    require 'net/http'
    require 'net/https'
    require 'json'

    def index
        private_key = 'fa7e33fe2f2b59db9395e4aac685ef54592aaa9307460c629bde0004363093568a13f8fbf995764ed26da6eed86c6404bb50cbc33eb07c14eeac28d35ef013be'
        data = URI.encode_www_form({"command" => "returnBalances", "nonce" => 2})
        digest = OpenSSL::Digest.new('sha512')
        signature = OpenSSL::HMAC.hexdigest(digest, private_key, data)
        uri = URI.parse('https://poloniex.com/tradingApi')
        https = Net::HTTP.new(uri.host,uri.port)
        https.use_ssl = true
        header = {"Sign": signature, "Key": 'DPFOLKO8-9IM5XU9T-9HZBG4JG-4FE54HI7', 
        'Content-Type': 'application/x-www-form-urlencoded'}
        req = https.post(uri.path, data, header)
        @show = req.body
    end

end