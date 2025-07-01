#!/bin/sh

mc alias set minio http://minio:9000 minioadmin minioadmin

sleep 2

mc mb minio/momento || true

mc anonymous set none minio/momento
echo "init" | mc pipe minio/momento/.keep
mc anonymous set download minio/momento

mc alias set minio http://minio:9000 minioadmin minioadmin

mc admin user add minio momentoapp momentoappsecret || true


cat <<EOF > /tmp/momento-access.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject"],
      "Resource": "arn:aws:s3:::momento/*"
    }
  ]
}
EOF

mc admin policy create minio momentoapp-access /tmp/momento-access.json || true
mc admin policy attach minio momentoapp-access --user momentoapp || true
