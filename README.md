# IL_cooperative_aerial_manipulation

Imitation learning for cooperative aerial manipulation: three drones carry one payload on cables, and
each drone flies its own student policy, trained by DAgger to imitate Sun's centralised NMPC. The
training runs in Isaac Lab with many environments in parallel.

This repository holds the Docker setup and pins the two code repositories as submodules:

| Submodule | What it is |
|---|---|
| `IL_cooperative_aerial_manipulation_ext` | Isaac Lab extension: the flycrane task, the teacher, the students, DAgger, offline training and validation scripts |
| `python_mpc_cusadi` | Sun's NMPC, batched over environments and solved by acados on CPU threads |

## Quick start

Requirements: an NVIDIA GPU with its driver, Docker with Compose and the NVIDIA Container Toolkit, and
access to `nvcr.io/nvidia/isaac-lab:3.0.0-beta2-post1`.

```bash
git clone --recursive git@github.com:Aerial-Manipulation-Lab/IL_cooperative_aerial_manipulation.git
cd IL_cooperative_aerial_manipulation && ./docker/dev.sh build
```

Then fly the teacher along the Medium figure eight; the video lands in `videos/`:

```bash
./docker/dev.sh run --rm isaac bash -c '$ISAAC_PY IL_cooperative_aerial_manipulation_ext/scripts/play.py \
    --task Flycrane-FigureEightMedium-v0 --teacher --headless --video'
```

The image is a development environment: it holds Isaac Lab, acados and the Python dependencies,
and the compose file mounts this checkout into the container, so it runs the code as checked out
(both submodules). The first run that uses the teacher generates and compiles the acados solver,
about a minute, cached in `.cache/python_mpc_cusadi`. There is no GUI in the container; flights are
watched as videos.

## Running

Every script runs in the container from the repository root, and writes to `logs/`:

```bash
# DAgger: train a student against the teacher, 8 environments in parallel
./docker/dev.sh run --rm isaac bash -c '$ISAAC_PY IL_cooperative_aerial_manipulation_ext/scripts/dagger.py \
    --task Flycrane-RandomTrajectoryFastHeavy-v0 --student baseline --dagger decay --num_envs 8 \
    --run_name my-run --headless'

# Validate a student on every test reference, 4 flights each
./docker/dev.sh run --rm isaac bash -c '$ISAAC_PY IL_cooperative_aerial_manipulation_ext/scripts/validate.py \
    --checkpoint logs/dagger/my-run/round_024.pt --flights 4 --headless'

# Fly a trained student instead of the teacher
./docker/dev.sh run --rm isaac bash -c '$ISAAC_PY IL_cooperative_aerial_manipulation_ext/scripts/play.py \
    --task Flycrane-FigureEightMedium-v0 --checkpoint logs/dagger/my-run/round_024.pt --headless --video'

# The teacher on the same references
./docker/dev.sh run --rm isaac bash -c '$ISAAC_PY IL_cooperative_aerial_manipulation_ext/scripts/validate.py \
    --teacher --flights 4 --headless'

# Train a student offline on the recorded flights of one or more DAgger runs
./docker/dev.sh run --rm isaac bash -c '$ISAAC_PY IL_cooperative_aerial_manipulation_ext/scripts/train.py \
    logs/dagger/my-run/rollouts --student load_reference_cable_direction --run_name my-offline-run'
```

The students' input sets are in `STUDENTS`, the DAgger and offline training settings in `DAGGER`
and `TRAINING` (`imitation/configs.py`), and the test references in `VALIDATION`.

## Versions

v0.1.0: Isaac Lab 3.0.0-beta2-post1, acados v0.6.0, CasADi 3.6.7.

## Licence

See `LICENCE`.
