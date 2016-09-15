class AddServerStateToAwsInstanceLogs < ActiveRecord::Migration
  def change
  	add_column :server_state, :aws_instance_logs, :string
  end
end
