module EbxDeliver
  module Writer 
    module Client
      class V20111205 < AWS::DynamoDB::Client

        def self.service_name
          'DynamoDB'
        end

        define_client_methods('2011-12-05')
      end
    end

    class Request < AWS::DynamoDB::Request
    end
  end
end
