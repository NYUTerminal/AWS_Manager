require 'aws-sdk'
require 'optparse'
require 'yaml'
require 'json'

module AwsHelper

  def self.initialize
    # setup
    auth = JSON.load(File.read(Dir.home + '/.aws/secret.json'))
    Aws.config.update({region: auth['region'],credentials: Aws::Credentials.new(auth['aws_access_key_id'], auth['aws_secret_access_key'])})
    @aws_ec2 = Aws::EC2::Instance.new auth['instance']
  end

  def self.start
    
  end

  def self.stop
    
  end

  def self.status
    initialize
    puts "Instance #{@aws_ec2.instance_id} is #{@aws_ec2.state.name}"
    @status = @aws_ec2.state.name
  end
end
