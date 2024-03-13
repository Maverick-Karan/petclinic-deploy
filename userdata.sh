#!/bin/bash

# Create the CloudWatch agent configuration file
cat <<EOF | sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/messages",
                        "log_group_name": "my-log-group",
                        "log_stream_name": "{instance_id}-messages",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/auth.log",
                        "log_group_name": "my-log-group",
                        "log_stream_name": "{instance_id}-auth",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/cloud-init.log",
                        "log_group_name": "my-log-group",
                        "log_stream_name": "{instance_id}-cloud-init",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/cloud-init-output.log",
                        "log_group_name": "my-log-group",
                        "log_stream_name": "{instance_id}-cloud-init-output",
                        "timezone": "UTC"
                    }
                ]
            }
        }
    },
    "metrics": {
        "append_dimensions": {
            "InstanceId": "\${aws:InstanceId}"
        },
        "metrics_collected": {
            "cpu": {
                "measurement": [
                    "cpu_usage_idle",
                    "cpu_usage_iowait"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "*"
                ]
            },
            "disk": {
                "measurement": [
                    "used_percent"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "/"
                ]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 60
            },
            "swap": {
                "measurement": [
                    "swap_used_percent"
                ],
                "metrics_collection_interval": 60
            }
        }
    }
}
EOF


# Start the CloudWatch agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s


docker pull docker pull maverick8266/petclinic:14
docker run -e MYSQL_URL=jdbc:mysql://${mysql_url}/petclinic -e DATABASE_TYPE=mysql -e SPRING.PROFILES.ACTIVE=mysql -p 80:8080 maverick8266/petclinic:14