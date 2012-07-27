module Stormpath

  module Http

    class HttpClientRequestExecutor

      include Stormpath::Http::Authc
      include Stormpath::Util::Assert

      def initialize(api_key)
        @signer = Sauthc1Signer.new
        @api_key = api_key
        @http_client = HTTPClient.new

      end

      def execute_request(request)

        assert_not_nil request, "Request argument cannot be null."

        @signer.sign_request request, @api_key

        domain = request.href

        method = @http_client.method(request.http_method.downcase)

        if request.body.nil?

          response = method.call domain, request.query_string, request.http_headers

        else

          add_query_string domain, request.query_string

          response = method.call domain, request.body, request.http_headers

        end

        Response.new response.http_header.status_code,
                     response.http_header.body_type,
                     response.content,
                     response.http_header.body_size

      end

      private

      def add_query_string href, query_string

        query_string.each do |key, value|

          if href.include? '?'

            href << '&' << key.to_s << '=' << value.to_s

          else
            href << '?' << key.to_s << '=' << value.to_s
          end

        end

      end

    end

  end

end

