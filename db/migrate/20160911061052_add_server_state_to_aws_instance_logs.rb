class AddServerStateToAwsInstanceLogs < ActiveRecord::Migration
  def change
  	add_column :aws_instance_logs, :server_state, :string
  end
end
