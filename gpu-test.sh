#!/bin/bash
echo "Testing GPU availability..."
conda run -n credit python -c "import torch; print(\"CUDA available?\", torch.cuda.is_available())"
