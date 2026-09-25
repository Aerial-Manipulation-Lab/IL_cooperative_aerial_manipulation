FROM nvcr.io/nvidia/isaac-lab:3.0.0-beta2-post1

ENV ISAAC_PY=/workspace/isaaclab/_isaac_sim/python.sh
ENV ACCEPT_EULA=Y
ENV ACADOS_SOURCE_DIR=/opt/acados
ENV LD_LIBRARY_PATH=/opt/acados/lib
ENV HOME=/home/isaac

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential cmake git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone acados
RUN git clone https://github.com/PriviligedLearningDistributedAerial/acados.git /opt/acados \
    && cd /opt/acados \
    && git checkout ca1a006eaa302ccd14bd266c0751afc3b3a306d3 \
    && git submodule update --recursive --init \
    && mkdir -p build && cd build \
    && cmake -DACADOS_WITH_QPOASES=ON -DCMAKE_INSTALL_PREFIX=/opt/acados .. \
    && make install -j"$(nproc)"

# Template renderer used for acados code generation
RUN mkdir -p /opt/acados/bin \
    && curl -sSL https://github.com/acados/tera_renderer/releases/download/v0.0.34/t_renderer-v0.0.34-linux \
         -o /opt/acados/bin/t_renderer \
    && chmod +x /opt/acados/bin/t_renderer

# Intsall python dependencies, into Isaac's own site-packages


COPY python_mpc_cusadi /opt/python_mpc_cusadi
RUN ${ISAAC_PY} -m pip install --no-cache-dir \
        "casadi==3.6.7" \
        pandas \
        cython \
    && ${ISAAC_PY} -m pip install --no-cache-dir -e /opt/acados/interfaces/acados_template \
    && ${ISAAC_PY} -m pip install --no-cache-dir -e "/opt/python_mpc_cusadi[acados]"

RUN ${ISAAC_PY} -c "\
import casadi, pandas, numpy, torch; \
from acados_template import AcadosOcpSolver; \
import python_mpc_cusadi; \
print('acados + casadi', casadi.__version__, '| numpy', numpy.__version__, '| torch', torch.__version__)"


ENTRYPOINT []

WORKDIR /workspace

# Runtime UID/GID is passed in at `docker run --user`, not baked into the
# image, so a rebuild is never needed when your host UID/GID changes. So
# instead of creating a matching user at build time, just make sure these
# dirs are writable by whatever UID shows up at runtime.
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
