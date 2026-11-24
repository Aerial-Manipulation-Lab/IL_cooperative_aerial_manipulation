FROM nvcr.io/nvidia/isaac-lab:3.0.0

ENV ISAAC_PY=/workspace/isaaclab/_isaac_sim/python.sh
ENV ACCEPT_EULA=Y
ENV ACADOS_SOURCE_DIR=/opt/acados
ENV LD_LIBRARY_PATH=/opt/acados/lib
ENV HOME=/home/isaac

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential cmake git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# acados v0.6.0, with OpenMP for its batch calls
RUN git clone --branch v0.6.0 --depth 1 https://github.com/acados/acados.git /opt/acados \
    && cd /opt/acados \
    && git submodule update --recursive --init --depth 1 \
    && mkdir -p build && cd build \
    && cmake -DACADOS_WITH_QPOASES=ON -DACADOS_WITH_OPENMP=ON -DACADOS_NUM_THREADS=1 \
         -DCMAKE_INSTALL_PREFIX=/opt/acados -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
         -DCMAKE_C_FLAGS="-D_GNU_SOURCE -fpermissive -w" .. \
    && make install -j"$(nproc)"

# Template renderer used for acados code generation, the release acados v0.6.0 expects
RUN mkdir -p /opt/acados/bin \
    && curl -sSL https://github.com/acados/tera_renderer/releases/download/v0.2.1/t_renderer-v0.2.1-linux-amd64 \
         -o /opt/acados/bin/t_renderer \
    && chmod +x /opt/acados/bin/t_renderer

# Install the python dependencies into Isaac's own site-packages. The compose file mounts the
# submodule over /opt/batched_caml_nmpc, so the editable install follows the checkout.
COPY batched_caml_nmpc /opt/batched_caml_nmpc
RUN ${ISAAC_PY} -m pip install --no-cache-dir \
        "casadi==3.6.7" \
        pandas \
        cython \
    && ${ISAAC_PY} -m pip install --no-cache-dir -e /opt/acados/interfaces/acados_template \
    && ${ISAAC_PY} -m pip install --no-cache-dir -e "/opt/batched_caml_nmpc[acados]"

RUN ${ISAAC_PY} -c "\
import casadi, pandas, numpy, torch; \
from acados_template import AcadosOcpSolver; \
import batched_caml_nmpc; \
print('acados + casadi', casadi.__version__, '| numpy', numpy.__version__, '| torch', torch.__version__)"


ENTRYPOINT []

WORKDIR /workspace

RUN mkdir -p "$HOME/.cache/ov" \
             "$HOME/.cache/pip" \
             "$HOME/.cache/nvidia/GLCache" \
             "$HOME/.nv/ComputeCache" \
             "$HOME/.nvidia-omniverse/logs" \
             "$HOME/.local/share/ov/data" \
             "$HOME/Documents" \
             /isaac-sim/kit/cache /isaac-sim/kit/logs /isaac-sim/kit/data \
    && chmod -R a+rwX "$HOME" \
             /isaac-sim/kit/cache /isaac-sim/kit/logs /isaac-sim/kit/data \
             /workspace/isaaclab
