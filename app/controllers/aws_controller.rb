require 'aws-sdk'
require 'optparse'
require 'yaml'

class AwsController < ApplicationController

  def start
    AwsHelper.start
    respond_to do |format|
      format.html { render template: 'status/start' }
    end
  end

  def stop
    AwsHelper.stop
    respond_to do |format|
      format.html { render template: 'status/stop' }
    end
  end

  def status
    AwsHelper.status
    respond_to do |format|
      format.html { render template: 'status/start' }
    end
  end

end
