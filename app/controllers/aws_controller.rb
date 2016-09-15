require 'aws-sdk'
require 'optparse'
require 'yaml'
require 'json'

class AwsController < ApplicationController

  def start
    @aws_ec2 = AwsHelper.initialize
    @aws_ec2.start
    @aws_ec2.wait_until_running
    puts "Instance #{@aws_ec2.instance_id} is running"
    AwsInstanceLog.save_log(@aws_ec2.instance_id,'start','EC2','running')
    respond_to do |format|
      format.html { render template: 'status/start' }
    end
  end

  def stop
    @aws_ec2 = AwsHelper.initialize
    if @aws_ec2.state.name == "stopped"
      puts "Instance #{@aws_ec2.instance_id} was already stopped"
      return
    else
      @aws_ec2.stop
      @aws_ec2.wait_until_stopped
      puts "Instance #{@aws_ec2.instance_id} stopped"
    end
    AwsInstanceLog.save_log(@aws_ec2.instance_id,'stop','EC2','stopped')
    respond_to do |format|
      format.html { render template: 'status/stop' }
    end
  end

  def status
    @aws_ec2 = AwsHelper.initialize
    # byebug
    puts "Instance #{@aws_ec2.instance_id} is #{@aws_ec2.state.name}"
    @status = @aws_ec2.state.name
    AwsInstanceLog.save_log(@aws_ec2.instance_id,'status','EC2',@status)

    respond_to do |format|
      format.html { render template: 'status/status' }
    end
  end

end
