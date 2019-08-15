# ceph-toolkit
ceph managing toolkit

# tools list
## bucket_index_cleaner.sh

It can be used to clean the dirty data storaged in bucket index shard object.

### applicable scene

If you delete the data pool but there is still some object list data storaged
in bucket index shard object in bucket index pool.

### usage method

./bucket_index_cleaner.sh $YOUR_BUCKET_NAME $YOUR_BUCKET_ID
