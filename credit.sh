#! /bin/bash
nvidia-smi
echo shmem
df -h /dev/shm
cp -r /glade/campaign/cisl/vast/pearse/wxformer_1h/finetune_final /checkpoint
cp /glade/campaign/cisl/vast/pearse/save_loc_dynamic_forcing/solar_irradiance_2025-01-01_0000_2025-12-31_2300.nc /checkpoint
export PATH=/home/ubuntu/.local/bin:$PATH
#git clone -q https://github.com/NCAR/CIRRUS-MILES-CREDIT.git
#git pull -q
python -m pip install xesmf
conda install -c conda-forge esmpy yaml -y
echo conda contents
conda install -y -c conda-forge "hdf5=*=nompi_*" "libnetcdf=*=nompi_*" "netcdf4=*=nompi_*"
echo "GFS INIT!!!!"
python /workspace/miles-credit/applications/gfs_init.py -c /workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml
mkdir -p /output/wxformer_1h_gfs
echo "ROLLOUT REALTIME"
ls -lrth /checkpoint
python /workspace/miles-credit/applications/rollout_realtime.py -c /workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml
ls -a /output
