module EbxDeliver
  module Writer 
    module Client
      class V20111205 < AWS::DynamoDB::Client

        def initialize(options = {})
          super(options)
          @net_http_handler = @http_handler
          @sns_handler = Writer::SNSHandler.new
        end

        def self.service_name
          'DynamoDB'
        end

        define_client_methods('2011-12-05')
        api_config = load_api_config('2011-12-05')
        api_config[:operations].each do |operation|
          method_name = operation[:method]
          define_method(method_name) do |*args, &block|
            options = args.first ? args.first : {}
            set_http_handler(method_name)
            client_request(method_name, options, &block)
          end
        end

        def set_http_handler(method_name)
          @http_handler = case method_name
                          when :batch_get_item,
                            :describe_table,
                            :get_item,
                            :list_tables,
                            :query,
                            :scan
                            @net_http_handler
                          else
                            @sns_handler
                          end
        end
      end
    end

    class Request < AWS::DynamoDB::Request
    end
  end
end
