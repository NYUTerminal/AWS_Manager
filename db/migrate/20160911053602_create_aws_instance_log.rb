class CreateAwsInstanceLog < ActiveRecord::Migration
  def change
    create_table :aws_instance_logs do |t|
      t.string :instance_name
      t.string :action
      t.string :server_type
      t.timestamps null: false
    end
  end
end
