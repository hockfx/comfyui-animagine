# ─── Base limpia sin modelos (~8GB vs 23GB del sdxl) ────────────────────────
FROM runpod/worker-comfyui:5.8.5-base

# ─── Descargar Animagine XL 3.1 usando comfy-cli (ruta correcta garantizada)
RUN comfy model download \
    --url "https://huggingface.co/cagliostrolab/animagine-xl-3.1/resolve/main/animagine-xl-3.1.safetensors" \
    --relative-path models/checkpoints \
    --filename animagine-xl-3.1.safetensors

# ─── Verificar ───────────────────────────────────────────────────────────────
RUN ls -lh /comfyui/models/checkpoints/
