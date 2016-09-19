require 'aws-sdk'
require 'optparse'
require 'yaml'
require 'json'

class Api::V1::AwsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def start
    @aws_ec2 = AwsHelper.initialize
    @aws_ec2.start
    @aws_ec2.wait_until_running
    puts "Instance #{@aws_ec2.instance_id} is running"
    @server_status = AwsInstanceLog.save_log(@aws_ec2.instance_id,'start','EC2','running')
    respond_to do |format|
      format.json {render json: @server_status,status: :ok}
    end
  end

  def stop
    @aws_ec2 = AwsHelper.initialize
    if @aws_ec2.state.name == "stopped"
      puts "Instance #{@aws_ec2.instance_id} was already stopped"
    else
      @aws_ec2.stop
      @aws_ec2.wait_until_stopped
      puts "Instance #{@aws_ec2.instance_id} stopped"
      @server_status = AwsInstanceLog.save_log(@aws_ec2.instance_id,'stop','EC2','stopped')
    end

    respond_to do |format|
      format.json {render json: @server_status,status: :ok}
    end
  end

  def status
    @aws_ec2 = AwsHelper.initialize
    puts "Instance #{@aws_ec2.instance_id} is #{@aws_ec2.state.name}"
    @status = @aws_ec2.state.name
    @server_status = AwsInstanceLog.save_log(@aws_ec2.instance_id,'status','EC2',@status)

    respond_to do |format|
      format.json {render json: @server_status,status: :ok}
    end
  end

  # Lot of same code from GET methods .. Can be optimized . If we can write it to helper methods.
  def start_instance
    begin
      @aws_ec2 = AwsHelper.post_initialize(contact_params)
      @aws_ec2.start
      @aws_ec2.wait_until_running
      puts "Instance #{@aws_ec2.instance_id} is running"
      @server_status = AwsInstanceLog.save_log(@aws_ec2.instance_id,'start','EC2','running')
      # @server_status = AwsInstanceLog.where(id: id).first
      respond_to do |format|
        format.json {render json: @server_status,status: :ok}
      end
    rescue => ex
      render json: ex.message, status: :unprocessable_entity
    end
  end

  def stop_instance
    begin
      @aws_ec2 = AwsHelper.post_initialize(contact_params)
      if @aws_ec2.state.name == "stopped"
        puts "Instance #{@aws_ec2.instance_id} was already stopped"
      else
        @aws_ec2.stop
        @aws_ec2.wait_until_stopped
        puts "Instance #{@aws_ec2.instance_id} stopped"
        @server_status = AwsInstanceLog.save_log(@aws_ec2.instance_id,'stop','EC2','stopped')
      end

      respond_to do |format|
        format.json {render json: @server_status,status: :ok}
      end
    rescue => ex
      render json: ex.message, status: :unprocessable_entity
    end

  end

  def status_instance
    begin
      @aws_ec2 = AwsHelper.post_initialize(contact_params)
      puts "Instance #{@aws_ec2.instance_id} is #{@aws_ec2.state.name}"
      @status = @aws_ec2.state.name
      @server_status = AwsInstanceLog.save_log(@aws_ec2.instance_id,'status','EC2',@status)

      respond_to do |format|
        format.json {render json: @server_status,status: :ok}
      end
    rescue => ex
      render json: ex.message, status: :unprocessable_entity
    end

  end

  def contact_params
    params.permit(:aws_access_key_id, :aws_secret_access_key, :region,:instance)
  end

end
