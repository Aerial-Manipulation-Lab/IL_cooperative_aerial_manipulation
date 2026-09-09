#!/usr/bin/env bash
#SBATCH --qos=short
#SBATCH --time=00:20:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --exclude=cor1
#SBATCH --output=run/output/flycrane-llc-%j.out
#SBATCH --error=run/output/flycrane-llc-%j.err
#SBATCH --mail-type=END,FAIL
#
# The #SBATCH pragmas above only take effect when this script is submitted
# with `sbatch run.sh slurm ...`, which happens automatically below - they are
# ignored for a plain `./run.sh local ...` run. --mail-user comes from
# slurm.env, not a pragma here, since it's personal and slurm.env is gitignored.
set -eu

usage() {
  echo "Usage: $0 {slurm|local} [extra args passed to the script]" >&2
  exit 1
}

TARGET="${1:-}"
case "$TARGET" in
  slurm|local) ;;
  *) usage ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1090
. "$SCRIPT_DIR/$TARGET.env"

# For slurm, submit ourselves as a job unless we're already running as one.
if [ "$TARGET" = "slurm" ] && [ -z "${SLURM_JOB_ID:-}" ]; then
  exec sbatch --mail-user="$SLURM_MAIL_USER" "$0" "$@"
fi
shift

NUM_ENVS="${NUM_ENVS:-1}"
VIDEO="${VIDEO:-1}"
CAM_ARGS=()
VIDEO_ARGS=()
if [ "$VIDEO" = "1" ]; then
  CAM_ARGS=(--env ENABLE_CAMERAS=1)
  VIDEO_ARGS=(--video)
fi

WORK="/tmp/$USER/isaac-run"
mkdir -p "$WORK/tmp" "$WORK/kit-data" "$WORK/cache"

cd "$REPO"

CMD=(
  apptainer exec --nv
  --pwd "$PWD"
  --env VK_ICD_FILENAMES=/etc/vulkan/icd.d/nvidia_icd.json
  "${CAM_ARGS[@]}"
  --env PYTHONPATH="$EXT_PYTHONPATH"
  "${BIND_ARGS[@]}"
  -B "$REPO":"$REPO"
  -B "$WORK/tmp":/tmp
  -B "$WORK/kit-data":/isaac-sim/kit/data
  -B "$WORK/cache":/isaac-sim/kit/cache
  "$SIF"
  /workspace/isaaclab/isaaclab.sh -p "$REPO/$SCRIPT_REL"
    --headless --num_envs "$NUM_ENVS"
)
[ -n "$ASSET_ARGS" ] && CMD+=("$ASSET_ARGS")
CMD+=("${VIDEO_ARGS[@]}")
CMD+=("$@")

if [ "$TARGET" = "slurm" ]; then
  srun "${CMD[@]}"
else
  "${CMD[@]}"
fi
