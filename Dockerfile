# ─── Base: worker-comfyui oficial de RunPod con SDXL ────────────────────────
FROM runpod/worker-comfyui:5.8.5-sdxl

# ─── Descargar Animagine XL 3.1 durante el build ────────────────────────────
# El modelo se bake en la imagen — sin Network Volume, sin descarga en runtime
RUN wget -q --show-progress \
    -O /comfyui/models/checkpoints/animagine-xl-3.1.safetensors \
    "https://huggingface.co/cagliostrolab/animagine-xl-3.1/resolve/main/animagine-xl-3.1.safetensors"

# ─── Verificar que el archivo quedó correctamente ───────────────────────────
RUN ls -lh /comfyui/models/checkpoints/
