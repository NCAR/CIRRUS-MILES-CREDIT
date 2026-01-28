#! /bin/bash
#nvidia-smi
export PATH=/home/ubuntu/.local/bin:$PATH
echo "miles-credit commit:"
git -C /workspace/miles-credit log -1 --format=%H
echo "gfs_init.py!"
# Create /output/model_predict in case it does not exist
mkdir -p /output/model_predict
ls -lrth /output
# Remove all directories but the 4 most recently created outputs
#ls -1dt /output/model_predict/* | tail -n +5 | xargs -r rm -rf
ls -1dt /output/model_predict | tail -n +5 | xargs -r rm -rf
rm -rf /output/gfs_init*.zarr
conda run -n credit python -u /workspace/miles-credit/applications/gfs_init.py -c ./model_predict_old.yml
echo "rollout_realtime.py!"
conda run -n credit python -u /workspace/miles-credit/applications/rollout_realtime.py -c ./model_predict_old.yml
ls -lrth /output
