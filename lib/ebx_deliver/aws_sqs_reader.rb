module EbxDeliver
  class AwsSqsReader

    def initialize
      # TODO pull name from settings
      @queue = AWS.sqs.queues.named('write-development-sqs')
      @db = AWS::DynamoDB.new
    end

    # TODO Fix
    def response_pool
      r = AWS.config.region
      AWS.config(region: 'us-west-2')
      @command_notifications ||= AWS.sns.topics.create('read-development-sns')
    ensure
      AWS.config(region: r)
    end

    def connect!
      # TODO remove poll to avoid autodelete
      @queue.poll do |notification|
        msg = JSON.parse(JSON.parse(notification.body)['Message'])
        puts "MSG Received #{msg}"

        response = @db.client.send(msg['method'], msg['args'])
        puts "RESPONSE #{response.data}"

        response_pool.publish({
          request_id: msg['request_id'],
          response: response.http_response
        }.to_json)

        notification.delete
      end
    end
  end
end
