module EbxDeliver
  class AwsSqsReader

    def connect!
      # TODO pull name from settings
      @queue = sqs.queues.named('development-sns')
      @db = AWS::DynamoDB.new

      @queue.poll do |notification|
        msg = JSON.parse(JSON.parse(notification.body)['Message'])
        Rails.logger.info "MSG Received #{msg}"
        response = @db.send(msg['method'], *msg['args'])
      end
    end
  end
end
