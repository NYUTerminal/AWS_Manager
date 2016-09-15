class AwsInstanceLog < ActiveRecord::Base

	def self.save_log(instance_name , action , server_type , server_state)
		instance_log = AwsInstanceLog.new
		instance_log.instance_name = instance_name
		instance_log.action = action
		instance_log.server_type = server_type
		instance_log.server_state = server_state
		instance_log.save
	end

end