require 'aws-sdk'
require 'optparse'
require 'yaml'

class AwsController < ApplicationController

  def self.initialize
    # setup
    @auth = JSON.load(File.read(Dir.home + '/.aws/secret.json'))
    Aws.config.update({region: @auth['region'],credentials: Aws::Credentials.new(@auth['aws_access_key_id'], @auth['aws_secret_access_key'])})
    @aws_ec2 = Aws::EC2::Instance.new @auth['instance']
  end

  def start
    initialize
    @aws_ec2.start
    @aws_ec2.wait_until_running
    puts "Instance #{@aws_ec2.instance_id} is running"    AwsInstanceLog.save_log
    AwsInstanceLog.save_log(@auth['instance'],'start','EC2','running')
    respond_to do |format|
      format.html { render template: 'status/start' }
    end
  end

  def stop
    initialize
    if @aws_ec2.state.name == "stopped"
      puts "Instance #{@aws_ec2.instance_id} was already stopped"
      return
    else
      byebug
      @aws_ec2.stop
      @aws_ec2.wait_until_stopped
      puts "Instance #{@aws_ec2.instance_id} stopped"
    end
    AwsInstanceLog.save_log(@auth['instance'],'stop','EC2','stopped')
    respond_to do |format|
      format.html { render template: 'status/stop' }
    end
  end

  def status
    initialize
    puts "Instance #{@aws_ec2.instance_id} is #{@aws_ec2.state.name}"
    @status = @aws_ec2.state.name
    AwsInstanceLog.save_log(@auth['instance'],'status','EC2',@status)
    respond_to do |format|
      format.html { render template: 'status/status' }
    end
  end

end
