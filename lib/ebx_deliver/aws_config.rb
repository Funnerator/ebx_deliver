module EbxDeliver
  class AwsConfig < AWS::Core::Configuration

    def self.accepted_options
      self.superclass.accepted_options
    end

    def initialize(options = {})
      super(options.merge(AWS.config.supplied))
    end

    def dynamo_db_client
      Writer::Client::V20111205.new(config: self)
    end
  end
end
