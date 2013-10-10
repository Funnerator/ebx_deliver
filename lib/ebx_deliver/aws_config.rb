module EbxDeliver
  class AwsConfig < AWS::Core::Configuration

    def self.accepted_options
      self.superclass.accepted_options
    end

    def initialize(options = {})
      super(options.merge(AWS.config.supplied))
    end

    def http_handler
      Writer::SNSHandler.new
    end
  end
end
