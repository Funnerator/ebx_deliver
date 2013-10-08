module Dynamoid
  module Adapter
    module AwsMultiRegionAdapter
      extend AwsSdk
      extend self

      def connect!
        @@connection = ::EbxDeliver::DynamoDB.new
      end
    end
  end
end
