#! /bin/bash
echo foo
conda run -n credit python -m pip show miles-credit
#conda activate credit
nvidia-smi
echo shmem
df -h /dev/shm
cp -r /glade/campaign/cisl/vast/pearse/wxformer_1h/finetune_final /checkpoint
cp /glade/campaign/cisl/vast/pearse/save_loc_dynamic_forcing/solar_irradiance_2025-01-01_0000_2025-12-31_2300.nc /checkpoint
export PATH=/home/ubuntu/.local/bin:$PATH
cd /workspace/CIRRUS-MILES-CREDIT
git pull
#chmod 777 ./credit.sh
echo "GFS INIT!!!!"
#rm -rf /output/*
conda run -n credit python -u /workspace/miles-credit/applications/gfs_init.py -c /workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml
mkdir -p /output/wxformer_1h_gfs
echo "ROLLOUT REALTIME"
ls -lrth /checkpoint
conda run -n credit python -u /workspace/miles-credit/applications/rollout_realtime.py -c /workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml
ls -a /output

