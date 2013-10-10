module EbxDeliver
  module Writer 
    class SNSHandler
      attr_reader :response_queue

      def initialize
        @response_queue = AWS.sqs.queues.named('read-development-sqs')
      end

      def command_notifications
        r = AWS.config.region
        AWS.config(region: 'us-west-2')
        @command_notifications ||= AWS.sns.topics.create('write-development-sns')
      ensure
        AWS.config(region: r)
      end

      def handle(request, response, &read_block)
        name = request.headers['x-amz-target'].split('.')[-1].underscore
        options = JSON.parse(request.body).reduce({}) {|h, (k, v)| h[k.underscore] = v; h}
        puts request.http_method
        request_id = SecureRandom.uuid
        publish_command(request_id, name, options)

        retrieve_response(request_id, response)
      end

      def publish_command(request_id, name, args)
        command_notifications.publish({
          method: name,
          args: args,
          request_id: request_id
        }.to_json)
      end

      def retrieve_response(request_id, response)
        start_time = Time.now
        found = false
        loop do
          msgs = response_queue.receive_messages(limit: 10)
          msgs.each do |notification|
            msg = JSON.parse(JSON.parse(notification.body)['Message'])
            if msg['request_id'] == request_id
              found = true
              response.status = msg['response']['status']
              response.headers = msg['response']['headers']
              response.body= msg['response']['body']
              notification.delete
            end
          end

          break if found
          #raise 'Timeout' if (Time.now - start_time) > 5
        end

        nil
      end
    end
  end
end
