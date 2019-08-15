#!/bin/bash

BUCKET=$1
BUCKET_ID=$2

PROCESSED=false


for obj in `s3cmd ls s3://${BUCKET} | awk '{print $4}'`
do
    obj_name=`echo $obj | sed "s/s3:\/\/${BUCKET}\///g"`
    PROCESSED=false

    for bucket_index in `rados -p default.rgw.buckets.index ls | grep ${BUCKET_ID}`
    do
        for obj_index in `rados -p default.rgw.buckets.index listomapkeys $bucket_index`
        do
            if [[ $obj_index == $obj_name ]]; then
                echo $obj_index
                echo "---------------------------------------------"
                rados -p default.rgw.buckets.index rmomapkey $bucket_index $obj_index
                PROCESSED=true
                break
            fi
        done

        if [[ $PROCESSED == true ]]; then
            break
        fi
    done
done
