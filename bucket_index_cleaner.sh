#!/bin/bash

BUCKET=$1
BUCKET_ID=$2
VSTART_ENV=$3

PROCESSED=false

BUCKET_INDEX_CMD=""
LISTOMAP_CMD=""
RMOMAP_CMD=""
if [[ ${VSTART_ENV} == "true" ]]; then
    BUCKET_INDEX_CMD="./bin/rados -c ceph.conf -p default.rgw.buckets.index ls "
    LISTOMAP_CMD="./bin/rados -c ceph.conf -p default.rgw.buckets.index listomapkeys"
    RMOMAP_CMD="./bin/rados -c ceph.conf -p default.rgw.buckets.index rmomapkey"
else
    BUCKET_INDEX_CMD="rados -p default.rgw.buckets.index ls "
    LISTOMAP_CMD="rados -p default.rgw.buckets.index listomapkeys"
    RMOMAP_CMD="rados -p default.rgw.buckets.index rmomapkey"
fi


for obj in `s3cmd ls s3://${BUCKET} | awk '{print $4}'`
do
    obj_name=`echo $obj | sed "s/s3:\/\/${BUCKET}\///g"`
    PROCESSED=false

    for bucket_index in `$BUCKET_INDEX_CMD | grep ${BUCKET_ID}`
    do
        for obj_index in `eval "$LISTOMAP_CMD $bucket_index"`
        do
            if [[ $obj_index == $obj_name ]]; then
                echo $obj_index
                echo "---------------------------------------------"
                eval "$RMOMAP_CMD $bucket_index $obj_index"
                PROCESSED=true
                break
            fi
        done

        if [[ $PROCESSED == true ]]; then
            break
        fi
    done
done
