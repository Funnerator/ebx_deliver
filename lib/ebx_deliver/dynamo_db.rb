module EbxDeliver
  class DynamoDB < AWS::DynamoDB
    def initialize(options)
      super(options)
      @client = AwsSnsWriter.new
    end
  end
end
