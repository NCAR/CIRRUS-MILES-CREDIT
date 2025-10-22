#! /bin/bash
nvidia-smi
ls /glade/campaign/cisl/vast/pearse/credit_arxiv_models/wxformer_1h/finetune_final
export PATH=/home/ubuntu/.local/bin:$PATH
git -C /workspace/miles-credit pull -q
git -C /workspace/miles-credit branch
echo "GFS INIT!!!!"
conda run -n credit python -u /workspace/miles-credit/applications/gfs_init.py -c /workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml
mkdir -p /output/wxformer_1h_gfs
echo "ROLLOUT REALTIME"
cp /workspace/CIRRUS-MILES-CREDIT/output.py /workspace/miles-credit/credit
conda run -n credit python -u /workspace/miles-credit/applications/rollout_realtime.py -c ./model_predict_old.yml
ls -lrth /output
