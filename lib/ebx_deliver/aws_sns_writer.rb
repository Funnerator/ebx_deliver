module EbxDeliver
  class AwsSnsWriter
    attr_reader :command_pool

    def initialize
      # TODO fix 
      @command_pool = AWS.sns.topics.create('development-sns')
      @response_pool = AWS.sns.topics.create('development-response')
    end

    def method_missing(method, *args)
      sent = false
      response_pool.poll do |notification|
        if !sent
          command_pool.publish(
            method: method,
            args: args
          )
          sent = true
        end

        notification
      end
    end
  end
end
