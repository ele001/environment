## vLLM Deployment

1. Install uv.

    ```bash
    curl -LsSf https://astral.sh/uv/install.sh | sh
    ```

2. Install vLLM with uv.

    ``` bash
    uv venv --python 3.12 --seed
    source .venv/bin/activate
    uv pip install vllm --torch-backend=auto
    ```

3. Download any LLM from modelscope. Take [Qwen3-0.6B](https://www.modelscope.cn/models/Qwen/Qwen3-0.6B) as an example.

    ``` bash
    uv tool install modelscope  # install modelscope with uv
    modelscope download --model 'Qwen/Qwen3-0.6B' --local_dir ./Qwen3-0.6B/     # `--local_dir <dir>` specifies the installation directory
    ```

4. Deploy your LLM with vLLM.

    ``` bash
    vllm serve <model_path>
    ```

    For example, the following command deploys Qwen3-0.6B using GPU #6 and #7:

    ``` bash
    CUDA_VISIBLE_DEVICES="6,7" vllm serve Qwen3-0.6B/ \
        --host 0.0.0.0 \
        --port 26001 \
        --served-model-name Qwen3-0.6B \
        --gpu-memory-utilization 0.95 \
        --tensor-parallel-size 2 \
        --max-model-len 4096 \
        --trust-remote-code \
        --enforce-eager
    ```
    
    - `CUDA_VISIBLE_DEVICES` Specifies which GPUs to use.
    - `--port <PORT>` is the exposed API port.
    - `--served-model-name` is the model name exposed to clients. Use this name in API requests.
    - `--tensor-parallel-size <GPU_NUM>` should be exactly the same number as the devices specified by `CUDA_VISIBLE_DEVICES`.
    - `--max-model-len` is the total context length (input tokens + output tokens).
    - `--gpu-memory-utilization` is the distributed fraction of memory of each GPU (0–1).
    
    Below output indicates successful deployment.
    ``` bash
    (APIServer pid=2088646) INFO:     Started server process [2088646]
    (APIServer pid=2088646) INFO:     Waiting for application startup.
    (APIServer pid=2088646) INFO:     Application startup complete.
    ```

    vLLM also supprots deploying an embedding model.
    ``` bash
    CUDA_VISIBLE_DEVICES="0,1,2,3,4,5,6,7" \
    vllm serve /data2/models/Qwen/Qwen3-Embedding-4B \
    --host 0.0.0.0 \
    --port 8654 \
    --tensor-parallel-size 8 \
    --dtype bfloat16 \
    --max-model-len 4096 \
    --gpu-memory-utilization 0.8 \
    --served-model-name Qwen/Qwen-embedding
    ```

5. Call the LLM API in any way you like.

    ``` bash
    curl http://localhost:26001/v1/completions \
      -H "Content-Type: application/json" \
      -d '{
        "model": "Qwen3-0.6B",
        "prompt": "你是谁",
        "max_tokens": 50
      }'
    ```

    Below vLLM output records the successful response.
    ``` bash
    (APIServer pid=2097719) INFO:     127.0.0.1:50652 - "POST /v1/completions HTTP/1.1" 200 OK
    (APIServer pid=2097719) INFO 09-23 09:29:16 [loggers.py:123] Engine 000: Avg prompt throughput: 0.2 tokens/s, Avg generation throughput: 5.0 tokens/s, Running: 0 reqs, Waiting: 0 reqs, GPU KV cache usage: 0.0%, Prefix cache hit rate: 0.0%
    ```

## TODO
- Create a public model directory to store the downloaded LLMs.
- Pack up the uv environment as a docker image. Or, install an existing vLLM docker image from web.

## References
[uv document](https://docs.astral.sh/uv/#installation)

[vllm document](https://docs.vllm.ai/en/latest/getting_started/quickstart.html#installation)
