class DropAwsInstanceLog < ActiveRecord::Migration
  def change
  	drop_table :aws_instance_logs
  end
end
