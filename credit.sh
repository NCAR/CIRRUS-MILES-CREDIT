#! /bin/bash
nvidia-smi
ls /glade/campaign/cisl/vast/pearse/wxformer_1h/finetune_final
#mkdir -p /checkpoint/finetune_final
#cp -rv /glade/campaign/cisl/vast/pearse/wxformer_1h/finetune_final/* /checkpoint/finetune_final
#ls -lrth /checkpoint
#cp /glade/campaign/cisl/vast/pearse/save_loc_dynamic_forcing/solar_irradiance_2025-01-01_0000_2025-12-31_2300.nc /checkpoint
#echo "CHECKPOINT"
#ls /checkpoint
#echo "CHECKPOINT/FINETUNE_FINAL"
#ls /checkpoint/finetune_final
export PATH=/home/ubuntu/.local/bin:$PATH
#cd /workspace/CIRRUS-MILES-CREDIT
cd /workspace/miles-credit
git pull -q
#chmod 777 ./credit.sh
echo "GFS INIT!!!!"
rm -rf /output/*
conda run -n credit python -u /workspace/miles-credit/applications/gfs_init.py -c /workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml
mkdir -p /output/wxformer_1h_gfs
echo "ROLLOUT REALTIME"
#ls -lrth /checkpoint
cp /workspace/CIRRUS-MILES-CREDIT/output.py /workspace/miles-credit/credit
conda run -n credit python -u /workspace/miles-credit/applications/rollout_realtime.py -c /workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml
ls -lrth /output
