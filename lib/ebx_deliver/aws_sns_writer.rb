module EbxDeliver
  class AwsSnsWriter
    attr_accessor :db

    def initialize
      # TODO fix 
      @topic = AWS.sns.topics.create('development-sns')

      @db = AWS::DynamoDB.new
    end

    def batch_get_item(&block)
      @db.batch_get_item(&block)
    end

    def batch_write_item(options)
      @db.client.batch_write_item(options)
      @topic.publish({
        method: 'batch_write_item',
        args: [options]
      }.to_json)
    end

    def batch_delete_item(options)
      @topic.publish({
        method: 'batch_delete_item',
        args: [options]
      }.to_json)
    end

    def create_table(options = {})
      @topic.publish({
        method: 'create_table',
        args: [options]
      }.to_json)
    end

    def delete_item(options = {})
      @topic.publish({
        method: 'delete_item',
        args: [options]
      }.to_json)
    end

    def delete_table(options = {})
      @topic.publish({
        method: 'delete_table',
        args: [table_name]
      }.to_json)
    end

    def describe_table(options = {})
      @db.client.describe_table(options)
    end

    def get_item(table_name, key, options = {})
      @db.client.get_item(options)
    end

    def list_tables
      @db.client.list_tables(options)
    end

    def put_item(table_name, object, options = nil)
      @topic.publish({
        method: 'put_item',
        args: [table_name, object, options]
      }.to_json)
    end

    def query(table_name, opts = {})
      @db.client.query(options)
    end

    def scan(options)
      @db.client.scan(options)
    end

    def update_item(options = {})
      @topic.publish({
        method: 'update_item',
        args: [options]
      }.to_json)
    end

    def update_table(options = {})
      @topic.publish({
        method: 'update_item',
        args: [options]
      }.to_json)
    end

    def self.send_test
      w = AwsSnsWriter.new
      w.connect!

      w.create_table('testtt')
    end
  end
end
