require "excon"
require "faraday"
require "yajl/json_gem"
require "yaml"

class Gitcycle < Thor
  class Api
    class <<self

      def branch(method, params=nil)
        method, params = method_parameters(method, params)
        parse http.send(method, "/branch.json", params).body
      end

      def branch_schema
        parse http.get("/branch/new.json").body
      end

      def user
        parse http.get("/user.json").body
      end

      private

      def http
        options = { :ssl => { :verify => false } }
        @http ||= Faraday.new Gitcycle::Config.url, options do |conn|
          conn.request :url_encoded
          conn.adapter :excon
        end
        
        @http.headers['Authorization'] = "Token token=\"#{Gitcycle::Config.token}\""
        @http
      end

      def method_parameters(method, params)
        if method
          method = :post  if method == :create
          method = :put   if method == :update
        end

        if params.nil?
          method, params = :get, params
        end

        [ method, params ]
      end

      def parse(body)
        hash = JSON.parse(body)
        hash = Util.symbolize_keys(hash)
        parse_timestamps(hash)
      end

      def parse_timestamps(hash)
        hash.each do |key, value|
          hash[key] = Time.parse(value)  if key.to_s =~ /_at$/
        end
        hash
      end
    end
  end
end