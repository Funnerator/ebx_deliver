module EbxDeliver
  class AwsSqsReader
    def connect!
      # TODO pull name from settings
      @queue = sqs.queues.named('development-sns')

      @db = AWS::DynamoDB.new

      @queue.poll do |notification|
        msg = JSON.parse(JSON.parse(notification.body)['Message'])
        Rails.logger.info "MSG Received #{msg}"
        send(msg['method'], *msg['args'])
      end
    end

    def create_table(options)
      @db.client.create_table(options)
    end

    def batch_delete_item(options)
      @db.client.batch_delete_item(options)
    end

    def create_table(options = {})
      @db.client.create_table(options)
    end

    def delete_item(options = {})
      @db.client.delete_item(options)
    end

    def delete_table(options = {})
      @db.client.delete_table(options)
    end

    def put_item(table_name, object, options = {})
      table = @db.tables[table_name]
      table.load_schema
      table.items.create(
        object.delete_if{|k, v| v.nil? || (v.respond_to?(:empty?) && v.empty?)},
        options || {}
      )
    rescue AWS::DynamoDB::Errors::ConditionalCheckFailedException => e
      raise Dynamoid::Errors::ConditionalCheckFailedException        
    end

    def update_item(options = {})
      @db.client.update_item(options)
    end

    def update_table(options = {})
      @db.client.update_table(options)
    end
  end
end
