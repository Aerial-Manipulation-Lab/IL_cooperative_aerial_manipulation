# Isaac Lab + acados, for cooperative aerial manipulation.
#
# This image provides the ENVIRONMENT only. Project code (the Isaac extension and
# python_mpc_cusadi) is bind-mounted at run time so editing it does not require a
# rebuild -- see run/run.sh.
#
# Build:
#   docker build -t il-aerial:latest docker/
#
# Convert for DAIC (apptainer reads straight from the local docker daemon):
#   apptainer build il-aerial.sif docker-daemon://il-aerial:latest

FROM nvcr.io/nvidia/isaac-lab:3.0.0-beta2-post1

# Isaac's launcher, which starts the full Kit runtime. Only needed for scripts that
# actually use the simulator. MPC-only work (solving, tests, data processing) should
# use the bare interpreter underneath it instead -- same Python, same site-packages,
# but no Kit startup, no EULA gate and no OmniHub retries:
#   /workspace/isaaclab/_isaac_sim/kit/python/bin/python3
ENV ISAAC_PY=/workspace/isaaclab/_isaac_sim/python.sh

# Isaac Sim refuses to start without this. Accepted here on behalf of anyone using
# this image: https://www.nvidia.com/en-us/agreements/enterprise-software/isaac-sim-additional-software-and-materials-license/
# PRIVACY_CONSENT is deliberately left unset, which opts out of telemetry.
ENV ACCEPT_EULA=Y

ENV ACADOS_SOURCE_DIR=/opt/acados
# Set absolutely, not appended: the base image does not define LD_LIBRARY_PATH, so
# appending would leave a trailing ':' -- which the loader reads as "also search the
# current directory". If a future base image does set it, this must become an append.
ENV LD_LIBRARY_PATH=/opt/acados/lib

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential cmake git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# acados: the lab's fork, pinned to the commit agiclean/Dockerfile used.
#
# NOTE: no -fpermissive / -D_GNU_SOURCE / CMAKE_POLICY_VERSION_MINIMUM here, unlike
# a host build. This base is Ubuntu 24.04 with GCC 13.3 and CMake 3.28, which sit
# just below the thresholds where this 2024 C code stops compiling:
#   - GCC 14 promotes implicit-function-declaration and incompatible-pointer-types
#     to hard errors (qpOASES has a real pointer-type bug that then fails)
#   - CMake 4 removes support for cmake_minimum_required(<3.5), and acados says 3.1
# If the Isaac base image is ever bumped past either, add back:
#   -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_C_FLAGS="-D_GNU_SOURCE -fpermissive -w"
RUN git clone https://github.com/PriviligedLearningDistributedAerial/acados.git /opt/acados \
    && cd /opt/acados \
    && git checkout ca1a006eaa302ccd14bd266c0751afc3b3a306d3 \
    && git submodule update --recursive --init \
    && mkdir -p build && cd build \
    && cmake -DACADOS_WITH_QPOASES=ON -DCMAKE_INSTALL_PREFIX=/opt/acados .. \
    && make install -j"$(nproc)"

# Template renderer used for acados code generation. Fetched explicitly because
# acados' own auto-download prompts interactively and would hang a build.
RUN mkdir -p /opt/acados/bin \
    && curl -sSL https://github.com/acados/tera_renderer/releases/download/v0.0.34/t_renderer-v0.0.34-linux \
         -o /opt/acados/bin/t_renderer \
    && chmod +x /opt/acados/bin/t_renderer

# Python dependencies, into Isaac's own site-packages. Installing properly (rather
# than pip --target + PYTHONPATH) is the point of containerising: .pth files are
# executed, so acados_template's future_fstrings codec registers itself and no
# workaround is needed.
#
# numpy, scipy, pyyaml and torch already ship with the base image and are
# deliberately NOT reinstalled -- torch in particular is CUDA-matched.
# casadi is pinned to the version this acados fork was tested against.
RUN ${ISAAC_PY} -m pip install --no-cache-dir \
        "casadi==3.6.7" \
        pandas \
        cython \
    && ${ISAAC_PY} -m pip install --no-cache-dir -e /opt/acados/interfaces/acados_template

# Sanity check at build time rather than discovering breakage at run time.
RUN ${ISAAC_PY} -c "\
import casadi, pandas, numpy, torch; \
from acados_template import AcadosOcpSolver; \
print('acados + casadi', casadi.__version__, '| numpy', numpy.__version__, '| torch', torch.__version__)"

# The Isaac base image sets ENTRYPOINT=[/isaac-sim/runheadless.sh], which launches
# the streaming Isaac Sim app and silently swallows whatever command you pass to
# `docker run` -- your command becomes arguments to that script instead of running.
# Reset it so this image behaves like a normal one: `docker run <img> <cmd>` runs <cmd>.
#
# (apptainer never hit this because `apptainer exec` bypasses the entrypoint by
# design, which is why the same image behaved differently under the two runtimes.)
ENTRYPOINT []

WORKDIR /workspace
