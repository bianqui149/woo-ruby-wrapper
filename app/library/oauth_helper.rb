require "uri"
require "net/http"
require "securerandom"
require "openssl"
require "base64"

class OauthHelper
  def self.generate_oauth_nonce
    "#{Time.now.to_i}#{SecureRandom.hex(10)}#{SecureRandom.uuid}"
  end

  def self.generate_oauth_signature(http_method, base_url, params, consumer_secret, token_secret = "")
    sorted_params = params.sort.map { |k, v| "#{url_encode(k.to_s)}=#{url_encode(v.to_s)}" }.join('&')
    base_string = [
      http_method.upcase,
      url_encode(base_url),
      url_encode(sorted_params)
    ].join('&')

    signing_key = "#{url_encode(consumer_secret)}&#{url_encode(token_secret)}"
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, signing_key, base_string)
    Base64.strict_encode64(hmac)
  end

  def self.url_encode(string)
    URI.encode_www_form_component(string).gsub('+', '%20').gsub('%7E', '~')
  end

  def self.generate_signed_url(http_method, base_url, params, consumer_key, consumer_secret, token_secret = "")
    oauth_nonce = generate_oauth_nonce
    oauth_timestamp = Time.now.to_i.to_s

    params.merge!({
      'oauth_consumer_key' => consumer_key,
      'oauth_nonce' => oauth_nonce,
      'oauth_signature_method' => 'HMAC-SHA1',
      'oauth_timestamp' => oauth_timestamp,
      'oauth_version' => '1.0',
    })

    signature = generate_oauth_signature(http_method, base_url, params, consumer_secret, token_secret)
    params['oauth_signature'] = signature

    base_url + '?' + URI.encode_www_form(params)
  end
end
