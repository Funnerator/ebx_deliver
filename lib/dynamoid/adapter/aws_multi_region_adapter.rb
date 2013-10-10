require 'dynamoid/adapter/aws_sdk'

module Dynamoid
  module Adapter
    module AwsMultiRegionAdapter
      extend Dynamoid::Adapter::AwsSdk

      def self.connect!
        @@connection = AWS::DynamoDB.new(config: EbxDeliver::AwsConfig.new)
      end

      def self.connection
        @@connection
      end
    end
  end
end
