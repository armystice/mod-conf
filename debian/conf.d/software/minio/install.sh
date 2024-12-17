#!/bin/bash

wget https://dl.min.io/server/minio/release/linux-amd64/minio_20240622052645.0.0_amd64.deb
dpkg -i minio_20240622052645.0.0_amd64.deb

mkdir -p /mnt/minio
MINIO_ROOT_USER=admin MINIO_ROOT_PASSWORD=password minio server /mnt/minio --console-address ":9001"