# Experiments

Isaac unless noted. `validate.py`: every reference in one env, seed 0, students at round 24. Students: state MLP,
DAgger from scratch, 25 rounds, seed 42. Runs are in `logs/dagger/<run>`.

## Teachers

Bold: the better of the two Isaac teachers per reference; offline, the best sample spacing.

### Teacher, reference sampled every 0.1 s

- Reference stored every 0.1 s (the old default).
- Validate, 1 flight per reference.

| Reference | Pos (m) | Att (°) | Completed |
|---|---|---|---|
| Random figure 8 | 0.034 | **0.69** | 1/1 |
| Slow | 0.029 | 0.81 | 1/1 |
| Medium | 0.049 | 0.88 | 1/1 |
| Medium Plus | 0.052 | 3.02 | 1/1 |
| Fast | 0.119 | 5.05 | 1/1 |
| Circle | 0.026 | 0.55 | 1/1 |
| Square | 0.027 | **0.60** | 1/1 |

### Teacher, reference sampled every 0.01 s (current)

- Reference stored every env step (0.01 s).
- Validate, 4 flights per reference.

| Reference | Pos (m) | Att (°) | Completed |
|---|---|---|---|
| Random walk | 0.024 | 1.03 | 4/4 |
| Random figure 8 | **0.023** | 1.62 | 4/4 |
| Slow | **0.019** | **0.64** | 4/4 |
| Medium | **0.020** | **0.66** | 4/4 |
| Medium Plus | **0.026** | **2.89** | 4/4 |
| Fast | **0.070** | **4.96** | 4/4 |
| Circle | **0.020** | **0.44** | 4/4 |
| Square | **0.020** | **0.60** | 4/4 |

### Teacher on its own model (offline)

- No Isaac: the MPC's own prediction 0.01 s ahead is the next state.
- Only the reference sample spacing varies. Position against the exact reference.

| Reference | 0.1 s | 0.01 s | 0.001 s |
|---|---|---|---|
| Slow | 0.038 | 0.005 | **0.001** |
| Medium | 0.078 | 0.010 | **0.003** |
| Medium Plus | 0.083 | 0.037 | **0.036** |
| Fast | 0.178 | 0.067 | **0.062** |

## Students

All with the current teacher (0.01 s sampling), validate 4 flights per reference. Bold: best of these
students per reference.

### Random figure 8

- Trained on: random figure 8s (`Flycrane-FigureEight-v0`, 8 envs).
- Inputs: all.
- Run: `state-mlp/fig8-random_100hz-ref`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.088 | 3.7× | 2.70 | 2.6× | 4/4 |
| Random figure 8 | 0.067 | 2.9× | 3.52 | 2.2× | 4/4 |
| Slow | 0.043 | 2.3× | 1.55 | 2.4× | 4/4 |
| Medium | 0.088 | 4.4× | 2.53 | 3.8× | 4/4 |
| Medium Plus | 0.086 | 3.3× | 4.67 | 1.6× | 4/4 |
| Fast | 0.423 | 6.1× | 17.3 | 3.5× | 4/4 |
| Circle | 0.042 | 2.1× | **0.88** | 2.0× | 4/4 |
| Square | 0.033 | 1.7× | 1.24 | 2.1× | 4/4 |

### Random walk

- Trained on: random walks, gentle up to Medium Plus (`Flycrane-RandomTrajectory-v0`, 8 envs).
- Inputs: all.
- Run: `state-mlp/random-walk_100hz-ref`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.061 | 2.5× | 2.03 | 2.0× | 4/4 |
| Random figure 8 | 0.086 | 3.7× | 3.69 | 2.3× | 4/4 |
| Slow | 0.057 | 3.0× | 1.53 | 2.4× | 4/4 |
| Medium | 0.073 | 3.7× | 2.45 | 3.7× | 4/4 |
| Medium Plus | 0.120 | 4.6× | 5.58 | 1.9× | 4/4 |
| Fast | 0.434 | 6.2× | 17.8 | 3.6× | 4/4 |
| Circle | 0.047 | 2.4× | 1.14 | 2.6× | 4/4 |
| Square | 0.041 | 2.0× | 1.17 | 2.0× | 4/4 |

### Medium-to-Fast random walk

- Trained on: random walks at Medium, Medium Plus and Fast difficulty, equal shares
  (`Flycrane-RandomTrajectoryMediumToFast-v0`, 9 envs).
- Inputs: all.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.050 | 2.1× | 2.35 | 2.3× | 4/4 |
| Random figure 8 | 0.062 | 2.7× | 3.02 | 1.9× | 4/4 |
| Slow | 0.044 | 2.4× | 2.00 | 3.1× | 4/4 |
| Medium | 0.063 | 3.1× | 2.30 | 3.5× | 4/4 |
| Medium Plus | 0.092 | 3.5× | 3.80 | 1.3× | 4/4 |
| Fast | 0.220 | 3.2× | 8.68 | 1.8× | 4/4 |
| Circle | 0.027 | 1.4× | 1.72 | 4.0× | 4/4 |
| Square | **0.029** | 1.5× | 1.37 | 2.3× | 4/4 |

### Medium-to-Fast random walk, no payload position

- As Medium-to-Fast random walk, but the student never sees the payload position: the reference is given relative
  to the drone and `drone_pos_rel_payload` is removed. Cable direction kept.
- Branch: `experiment/no-payload-position`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_no-payload-position`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.147 | 6.2× | 3.72 | 3.6× | 4/4 |
| Random figure 8 | 0.166 | 7.2× | 4.38 | 2.7× | 4/4 |
| Slow | 0.140 | 7.5× | 3.09 | 4.8× | 4/4 |
| Medium | 0.146 | 7.3× | 4.11 | 6.2× | 4/4 |
| Medium Plus | 0.135 | 5.2× | 5.16 | 1.8× | 4/4 |
| Fast | 0.451 | 6.5× | 12.9 | 2.6× | 1/4 (3 ended: drones too close) |
| Circle | 0.071 | 3.5× | 1.78 | 4.1× | 4/4 |
| Square | 0.132 | 6.6× | 2.54 | 4.3× | 4/4 |

### Medium-to-Fast random walk, no payload position, no cable direction

- As above, and `drone_cable_dir` removed too.
- Branch: `experiment/no-payload-position_no-cable-dir`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_no-payload-position_no-cable-dir`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.146 | 6.1× | 3.61 | 3.5× | 4/4 |
| Random figure 8 | 0.127 | 5.5× | 4.14 | 2.6× | 4/4 |
| Slow | 0.163 | 8.7× | 4.33 | 6.7× | 4/4 |
| Medium | 0.234 | 12× | 5.23 | 7.9× | 4/4 |
| Medium Plus | 0.148 | 5.7× | 5.73 | 2.0× | 4/4 |
| Fast | – | – | – | – | 0/4 (drones too close) |
| Circle | 0.058 | 2.9× | 1.93 | 4.4× | 3/4 (1 ended: drones too close) |
| Square | 0.083 | 4.2× | 2.45 | 4.1× | 4/4 |

### Medium-to-Fast random walk, attach point only

- As Medium-to-Fast random walk, but no payload state at all: each drone gets its attach point's reference over the
  horizon (relative to the drone, with velocity and acceleration), its cable as a vector and its rate (differenced
  over one step), its own state and its attach point.
- Branch: `experiment/attach-point-reference`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_attach-point-reference`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.081 | 3.4× | 9.28 | 9.0× | 2/4 (2 ended: drones too close) |
| Random figure 8 | 0.232 | 10× | 10.5 | 6.5× | 1/4 (3 ended: drones too close) |
| Slow | – | – | – | – | 0/4 (drones too close) |
| Medium | – | – | – | – | 0/4 (drones too close) |
| Medium Plus | – | – | – | – | 0/4 (3 drones too close, 1 cables collide) |
| Fast | – | – | – | – | 0/4 (2 drones too close, 1 cables collide, 1 drone too low) |
| Circle | 0.054 | 2.7× | 5.99 | 14× | 3/4 (1 ended: drones too close) |
| Square | 0.099 | 5.0× | 6.04 | 10× | 2/4 (2 ended: drones too close) |

### Medium-to-Fast random walk, residual on each drone's reference

- As attach point only, plus where the drone itself should be over the horizon (the teacher's cable reference
  placed on the payload reference, from the reference alone), its cable tension reference and the attach-point
  error. Still no payload state.
- Label: the plan minus the drone's reference (position, velocity, acceleration; body rates in full). The action
  adds the reference back.
- Branch: `experiment/residual-feedforward`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_residual-feedforward`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.071 | 3.0× | 1.98 | 1.9× | 4/4 |
| Random figure 8 | 0.077 | 3.3× | 3.09 | 1.9× | 4/4 |
| Slow | 0.071 | 3.8× | 2.14 | 3.3× | 4/4 |
| Medium | 0.072 | 3.6× | 2.31 | 3.5× | 4/4 |
| Medium Plus | 0.085 | 3.2× | 4.54 | 1.6× | 4/4 |
| Fast | **0.111** | 1.6× | 9.12 | 1.8× | 4/4 |
| Circle | 0.080 | 4.0× | 1.63 | 3.7× | 4/4 |
| Square | 0.072 | 3.6× | 1.74 | 2.9× | 4/4 |

### Medium-to-Fast random walk, full state, residual on each drone's reference

- As Medium-to-Fast random walk (all inputs, payload state included), plus where the drone should be and its cable
  tension reference; label and action as the residual variant above.
- Branch: `experiment/full-state-residual`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_full-state-residual`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.063 | 2.6× | **1.46** | 1.4× | 4/4 |
| Random figure 8 | 0.056 | 2.4× | **2.08** | 1.3× | 4/4 |
| Slow | 0.062 | 3.3× | **1.11** | 1.7× | 4/4 |
| Medium | 0.066 | 3.3× | **1.19** | 1.8× | 4/4 |
| Medium Plus | 0.069 | 2.6× | **3.39** | 1.2× | 4/4 |
| Fast | 0.118 | 1.7× | **6.29** | 1.3× | 4/4 |
| Circle | 0.059 | 3.0× | 0.92 | 2.1× | 4/4 |
| Square | 0.058 | 2.9× | **0.94** | 1.6× | 4/4 |

### Medium-to-Fast random walk, drone reference as input only

- As the residual variant (no payload state, same inputs), but the label is the full plan relative to the drone,
  as for every other student; the drone reference is an input only.
- Branch: `experiment/feedforward-input`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_feedforward-input`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.048 | 2.0× | 1.97 | 1.9× | 4/4 |
| Random figure 8 | 0.048 | 2.1× | 2.90 | 1.8× | 4/4 |
| Slow | **0.029** | 1.5× | 1.40 | 2.2× | 4/4 |
| Medium | 0.045 | 2.3× | 2.02 | 3.0× | 4/4 |
| Medium Plus | 0.060 | 2.3× | 4.40 | 1.5× | 4/4 |
| Fast | 0.122 | 1.8× | 9.50 | 1.9× | 4/4 |
| Circle | **0.025** | 1.2× | 1.05 | 2.4× | 4/4 |
| Square | 0.032 | 1.6× | 1.23 | 2.1× | 4/4 |

### Medium-to-Fast random walk, drone reference as input only, no cable input

- As drone reference as input only, without `cable_attach_rel_drone`, its rate and `cable_attach_error`: no
  payload state and no cable measurement, only the references and the drone's own state (417 inputs).
- Branch: `experiment/no-cable-input` (worktree `.cache/worktrees/no-cable-input`, uncommitted).
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_no-cable-input`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | **0.043** | 1.8× | 2.12 | 2.1× | 4/4 |
| Random figure 8 | **0.046** | 2.0× | 3.37 | 2.1× | 4/4 |
| Slow | 0.036 | 1.9× | 1.41 | 2.2× | 4/4 |
| Medium | **0.042** | 2.1× | 2.10 | 3.2× | 4/4 |
| Medium Plus | **0.055** | 2.1× | 4.67 | 1.6× | 4/4 |
| Fast | 0.161 | 2.3× | 7.56 | 1.5× | 4/4 |
| Circle | 0.043 | 2.2× | 1.49 | 3.4× | 4/4 |
| Square | 0.036 | 1.8× | 1.53 | 2.6× | 4/4 |

### Medium-to-Fast random walk, drone reference only

- As no cable input, without the cable references (`cable_tension_ref_horizon`, `cable_attach_ref_horizon`) too:
  only the drone reference over the horizon, the drone's own state and its attach point (207 inputs).
- Branch: `experiment/drone-reference-only` (worktree `.cache/worktrees/drone-reference-only`, uncommitted).
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_drone-reference-only`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.054 | 2.3× | 3.16 | 3.1× | 4/4 |
| Random figure 8 | 0.077 | 3.3× | 4.53 | 2.8× | 4/4 |
| Slow | 0.035 | 1.8× | 3.27 | 5.1× | 4/4 |
| Medium | 0.051 | 2.6× | 4.24 | 6.4× | 4/4 |
| Medium Plus | 0.077 | 3.0× | 7.01 | 2.4× | 4/4 |
| Fast | 0.162 | 2.3× | 9.34 | 1.9× | 4/4 |
| Circle | 0.026 | 1.3× | 1.72 | 3.9× | 4/4 |
| Square | 0.029 | 1.5× | 1.86 | 3.1× | 4/4 |

### Medium-to-Fast random walk, no payload velocity

- As Medium-to-Fast random walk, without the payload's linear and angular velocity: only what motion capture and the
  drones' own filters give (411 inputs).
- Branch: `experiments` (455be62), student `baseline`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_no-payload-velocity`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.060 | 2.5× | 2.21 | 2.1× | 4/4 |
| Random figure 8 | 0.065 | 2.8× | 3.20 | 2.0× | 4/4 |
| Slow | 0.037 | 2.0× | 2.00 | 3.1× | 4/4 |
| Medium | 0.063 | 3.2× | 2.52 | 3.8× | 4/4 |
| Medium Plus | 0.081 | 3.1× | 4.53 | 1.6× | 4/4 |
| Fast | 0.279 | 4.0× | 13.4 | 2.7× | 4/4 |
| Circle | 0.031 | 1.5× | 1.27 | 2.9× | 4/4 |
| Square | 0.036 | 1.8× | 1.45 | 2.4× | 4/4 |

### Medium-to-Fast random walk, payload reference only

- No payload or cable measurement: the payload reference over the horizon seen from the drone (orientation as is), the
  drone's own orientation and velocities, and its attach point (396 inputs). It has to learn where to stand itself.
- Branch: `experiments` (455be62), student `load_reference`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.112 | 4.7× | 6.06 | 5.9× | 4/4 |
| Random figure 8 | 0.157 | 6.8× | 7.99 | 4.9× | 4/4 |
| Slow | 0.113 | 5.9× | 5.15 | 8.0× | 4/4 |
| Medium | 0.134 | 6.7× | 7.07 | 11× | 4/4 |
| Medium Plus | 0.148 | 5.7× | 8.35 | 2.9× | 4/4 |
| Fast | – | – | – | – | 0/4 (drones too close) |
| Circle | 0.088 | 4.4× | 3.74 | 8.5× | 4/4 |
| Square | 0.161 | 8.1× | 8.69 | 14× | 4/4 |

### Medium-to-Fast random walk, payload reference only, 50 rounds

- As payload reference only, with 50 DAgger rounds instead of 25; its first 25 rounds are identical to that run's.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference_50-rounds`, validated at round 49.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.076 | 3.2× | 3.01 | 2.9× | 4/4 |
| Random figure 8 | 0.087 | 3.8× | 4.06 | 2.5× | 4/4 |
| Slow | 0.080 | 4.2× | 3.80 | 5.9× | 4/4 |
| Medium | 0.105 | 5.2× | 3.73 | 5.7× | 4/4 |
| Medium Plus | 0.100 | 3.8× | 6.15 | 2.1× | 4/4 |
| Fast | – | – | – | – | 0/4 (drones too close) |
| Circle | 0.060 | 3.0× | 2.82 | 6.4× | 4/4 |
| Square | 0.081 | 4.0× | 2.48 | 4.1× | 4/4 |

### Medium-to-Fast random walk, payload reference and cable direction, 50 rounds

- As payload reference only, 50 rounds, plus `cable_direction`: which way its cable runs, from the attach point up to
  the drone (399 inputs). Without motion capture on the payload this needs a cable estimator.
- Branch: `experiments` (455be62), student `load_reference_cable_direction`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference-cable-direction_50-rounds`, validated at round 49.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.088 | 3.7× | 3.02 | 2.9× | 4/4 |
| Random figure 8 | 0.074 | 3.2× | 4.51 | 2.8× | 4/4 |
| Slow | 0.070 | 3.7× | 2.80 | 4.4× | 4/4 |
| Medium | 0.072 | 3.6× | 4.17 | 6.3× | 4/4 |
| Medium Plus | 0.088 | 3.4× | 6.54 | 2.3× | 4/4 |
| Fast | 0.228 | 3.3× | 12.1 | 2.4× | 2/4 (1 cables too close, 1 drones too close) |
| Circle | 0.055 | 2.8× | 2.07 | 4.7× | 4/4 |
| Square | 0.071 | 3.6× | 2.05 | 3.4× | 4/4 |

### Medium-to-Fast random walk, payload reference and cable force, 50 rounds

- As payload reference only, 50 rounds, plus how its cable pulls on it as the drone senses it: `cable_force_direction`
  and `cable_tension`, from the sim's joint wrench at each drone's base link (400 inputs).
- Branch: `experiments` (455be62), student `load_reference_cable_force`.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference-cable-force_50-rounds`, validated at round 49.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.066 | 2.7× | 3.05 | 3.0× | 4/4 |
| Random figure 8 | 0.070 | 3.0× | 3.50 | 2.2× | 4/4 |
| Slow | 0.045 | 2.4× | 2.96 | 4.6× | 4/4 |
| Medium | 0.069 | 3.4× | 4.20 | 6.4× | 4/4 |
| Medium Plus | 0.085 | 3.3× | 5.75 | 2.0× | 4/4 |
| Fast | – | – | – | – | 0/4 (2 cables too close, 2 drones too close) |
| Circle | 0.045 | 2.2× | 2.58 | 5.9× | 4/4 |
| Square | 0.044 | 2.2× | 2.29 | 3.8× | 4/4 |

## Training settings, overnight 2026-11-03

Students without the drone reference, 100 DAgger rounds instead of 25 or 50, with other training settings. Run on the
throwaway branch `experiment/overnight-fast`; its settings are now named in `DAGGER` (`experiments` ac638e9), and the
Fast-heavy task is `Flycrane-RandomTrajectoryFastHeavy-v0`. Batch
`.cache/overnight_fast.sh`, logs in `logs/overnight_fast/`. Validated at round 99, 4 flights per reference. To compare: the
50-round cable-direction student, 0.074 m on average over the references other than Fast, Fast 2/4 at 0.228 m.

### 100 rounds, cable direction

- As the 50-round cable-direction student, run to 100 rounds; nothing else changed.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference-cable-direction_100-rounds`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.045 | 1.9× | 2.37 | 2.3× | 4/4 |
| Random figure 8 | 0.052 | 2.3× | 3.28 | 2.0× | 4/4 |
| Slow | 0.043 | 2.3× | 2.15 | 3.4× | 4/4 |
| Medium | 0.051 | 2.5× | 2.36 | 3.6× | 4/4 |
| Medium Plus | 0.062 | 2.4× | 4.52 | 1.6× | 4/4 |
| Fast | 0.125 | 1.8× | 8.59 | 1.7× | 4/4 |
| Circle | 0.036 | 1.8× | 1.38 | 3.1× | 4/4 |
| Square | 0.046 | 2.3× | 1.54 | 2.6× | 4/4 |

### 100 rounds, cable direction, learning rate decay

- As 100 rounds, with the learning rate falling from 1e-3 to 1e-5 along a cosine over the rounds.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference-cable-direction_100-rounds_decay`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.038 | 1.6× | 1.73 | 1.7× | 4/4 |
| Random figure 8 | 0.043 | 1.9× | 2.59 | 1.6× | 4/4 |
| Slow | 0.038 | 2.0× | 1.44 | 2.2× | 4/4 |
| Medium | 0.044 | 2.2× | 1.86 | 2.8× | 4/4 |
| Medium Plus | 0.051 | 2.0× | 4.06 | 1.4× | 4/4 |
| Fast | 0.135 | 1.9× | 10.5 | 2.1× | 4/4 |
| Circle | 0.024 | 1.2× | 1.02 | 2.3× | 4/4 |
| Square | 0.030 | 1.5× | 1.08 | 1.8× | 4/4 |

### 100 rounds, cable direction, learning rate decay, Fast-heavy walks

- As learning rate decay, trained on `Flycrane-RandomTrajectoryFastHeavy-v0`: half the walks at Fast (8 envs, 4 at Fast).
- Run: `state-mlp/random-walk-fast-heavy_100hz-ref_load-reference-cable-direction_100-rounds_decay`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.036 | 1.5× | 1.80 | 1.7× | 4/4 |
| Random figure 8 | 0.039 | 1.7× | 2.81 | 1.7× | 4/4 |
| Slow | 0.031 | 1.6× | 1.76 | 2.8× | 4/4 |
| Medium | 0.037 | 1.9× | 2.13 | 3.2× | 4/4 |
| Medium Plus | 0.053 | 2.0× | 3.85 | 1.3× | 4/4 |
| Fast | 0.130 | 1.9× | 9.35 | 1.9× | 4/4 |
| Circle | 0.027 | 1.4× | 1.11 | 2.5× | 4/4 |
| Square | 0.026 | 1.3× | 1.15 | 1.9× | 4/4 |

### 100 rounds, cable direction, learning rate decay, gate 0.1

- As learning rate decay, with the DAgger gate at 0.1 instead of 0.03: the student flies more of the time.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference-cable-direction_100-rounds_decay_gate-0.1`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.049 | 2.0× | 2.78 | 2.7× | 4/4 |
| Random figure 8 | 0.062 | 2.7× | 4.03 | 2.5× | 4/4 |
| Slow | 0.050 | 2.6× | 2.82 | 4.4× | 4/4 |
| Medium | 0.064 | 3.2× | 4.11 | 6.2× | 4/4 |
| Medium Plus | 0.074 | 2.8× | 5.67 | 2.0× | 4/4 |
| Fast | 0.173 | 2.5× | 12.9 | 2.6× | 4/4 |
| Circle | 0.044 | 2.2× | 1.41 | 3.2× | 4/4 |
| Square | 0.039 | 1.9× | 1.53 | 2.6× | 4/4 |

### 100 rounds, cable direction, learning rate decay, no gate

- As learning rate decay, without a gate: after round 0 the student always flies, the teacher only labels.
- Run: `state-mlp/random-walk-medium-to-fast_100hz-ref_load-reference-cable-direction_100-rounds_decay_no-gate`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.216 | 9.0× | 18.4 | 18× | 2/4 (1 cable angle at drone, 1 drones too close) |
| Random figure 8 | – | – | – | – | 0/4 (2 cable angle at payload, 2 drones too close) |
| Slow | – | – | – | – | 0/4 (1 cables too close, 3 drones too close) |
| Medium | – | – | – | – | 0/4 (1 cable angle at drone, 1 cable angle at payload, 2 drones too close) |
| Medium Plus | – | – | – | – | 0/4 (1 cable angle at payload, 1 cables too close, 1 drone too low, 1 drones too close) |
| Fast | – | – | – | – | 0/4 (1 cable angle at drone, 1 drone too low, 2 drones too close) |
| Circle | – | – | – | – | 0/4 (4 drones too close) |
| Square | – | – | – | – | 0/4 (1 cable angle at payload, 1 cables too close, 2 drones too close) |

### 100 rounds, cable direction, combo with gate 0.1

- Fast-heavy walks, 3 hidden layers of 512, learning rate decay and gate 0.1 together.
- Run: `state-mlp/random-walk-fast-heavy_100hz-ref_load-reference-cable-direction_100-rounds_decay_512_gate-0.1`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.069 | 2.9× | 4.30 | 4.2× | 4/4 |
| Random figure 8 | 0.070 | 3.0× | 5.06 | 3.1× | 4/4 |
| Slow | 0.047 | 2.5× | 3.95 | 6.2× | 4/4 |
| Medium | 0.068 | 3.4× | 4.94 | 7.5× | 4/4 |
| Medium Plus | 0.088 | 3.4× | 7.59 | 2.6× | 4/4 |
| Fast | 0.233 | 3.3× | 14.8 | 3.0× | 4/4 |
| Circle | 0.044 | 2.2× | 2.06 | 4.7× | 4/4 |
| Square | 0.043 | 2.1× | 2.96 | 4.9× | 4/4 |

### 100 rounds, cable direction, combo without a gate

- Fast-heavy walks, 3 hidden layers of 512, learning rate decay and no gate together.
- Run: `state-mlp/random-walk-fast-heavy_100hz-ref_load-reference-cable-direction_100-rounds_decay_512_no-gate`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | – | – | – | – | 0/4 (1 cable angle at payload, 2 drone too low, 1 drones too close) |
| Random figure 8 | – | – | – | – | 0/4 (1 cable angle at drone, 3 drone too low) |
| Slow | – | – | – | – | 0/4 (1 cable angle at drone, 1 cable angle at payload, 2 drone too low) |
| Medium | – | – | – | – | 0/4 (1 cable angle at drone, 3 drone too low) |
| Medium Plus | – | – | – | – | 0/4 (3 cable angle at payload, 1 drone too low) |
| Fast | – | – | – | – | 0/4 (1 cable angle at payload, 3 drone too low) |
| Circle | – | – | – | – | 0/4 (4 drone too low) |
| Square | 0.405 | 20× | 24.1 | 40× | 1/4 (1 cable angle at payload, 2 drone too low) |

### 100 rounds, payload reference only, combo with gate 0.1

- Student `load_reference` (no cable input) with the combo: Fast-heavy walks, 512, learning rate decay, gate 0.1.
- Run: `state-mlp/random-walk-fast-heavy_100hz-ref_load-reference_100-rounds_decay_512_gate-0.1`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.069 | 2.9× | 5.01 | 4.9× | 4/4 |
| Random figure 8 | 0.082 | 3.6× | 5.89 | 3.6× | 4/4 |
| Slow | 0.082 | 4.3× | 4.39 | 6.9× | 4/4 |
| Medium | 0.090 | 4.5× | 6.09 | 9.2× | 4/4 |
| Medium Plus | 0.085 | 3.3× | 7.34 | 2.5× | 4/4 |
| Fast | 0.224 | 3.2× | 16.7 | 3.4× | 4/4 |
| Circle | 0.046 | 2.3× | 2.07 | 4.7× | 4/4 |
| Square | 0.043 | 2.2× | 2.57 | 4.3× | 4/4 |

### 100 rounds, cable force, combo with gate 0.1

- Student `load_reference_cable_force` with the combo: Fast-heavy walks, 512, learning rate decay, gate 0.1.
- Run: `state-mlp/random-walk-fast-heavy_100hz-ref_load-reference-cable-force_100-rounds_decay_512_gate-0.1`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.056 | 2.3× | 3.40 | 3.3× | 4/4 |
| Random figure 8 | 0.067 | 2.9× | 4.55 | 2.8× | 4/4 |
| Slow | 0.048 | 2.5× | 2.58 | 4.0× | 4/4 |
| Medium | 0.073 | 3.7× | 3.48 | 5.3× | 4/4 |
| Medium Plus | 0.075 | 2.9× | 5.90 | 2.0× | 4/4 |
| Fast | 0.201 | 2.9× | 12 | 2.4× | 4/4 |
| Circle | 0.033 | 1.6× | 1.49 | 3.4× | 4/4 |
| Square | 0.035 | 1.8× | 1.65 | 2.8× | 4/4 |

### 100 rounds, no payload velocity, combo with gate 0.1

- Student `baseline` (payload measured, no payload velocity) with the combo: Fast-heavy walks, 512, learning rate decay, gate 0.1.
- Run: `state-mlp/random-walk-fast-heavy_100hz-ref_no-payload-velocity_100-rounds_decay_512_gate-0.1`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.042 | 1.7× | 1.75 | 1.7× | 4/4 |
| Random figure 8 | 0.048 | 2.1× | 2.40 | 1.5× | 4/4 |
| Slow | 0.026 | 1.3× | 1.26 | 2.0× | 4/4 |
| Medium | 0.043 | 2.2× | 1.60 | 2.4× | 4/4 |
| Medium Plus | 0.058 | 2.2× | 4.20 | 1.5× | 4/4 |
| Fast | 0.153 | 2.2× | 9.41 | 1.9× | 4/4 |
| Circle | 0.021 | 1.1× | 0.74 | 1.7× | 4/4 |
| Square | 0.027 | 1.4× | 0.82 | 1.4× | 4/4 |

## Offline training on recorded DAgger runs

Fresh students trained with `train.py` on the rollouts DAgger recorded, every 100 Hz step, with no new flying. Cable
direction (no payload state, no drone reference). Validated 4 flights per reference. `experiments` ac638e9, batch
`.cache/offline_training.sh`, logs in `logs/offline_training/` (the first in `logs/overnight_fast/every-step_*`).

### Offline, one run, quick

- A fresh cable-direction student trained on every recorded step of `state-mlp/random-walk-fast-heavy_100hz-ref_load-reference-cable-direction_100-rounds_decay`: 100 epochs of batch 4096 (about
  26k steps, 25 s on the GPU), learning rate halved when the held-out loss stalled (the old `train.py`).
- Checkpoint `logs/bc/every-step_fast-heavy-decay/best.pt`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.057 | 2.4× | 2.68 | 2.6× | 4/4 |
| Random figure 8 | 0.048 | 2.1× | 3.13 | 1.9× | 4/4 |
| Slow | 0.043 | 2.3× | 3.87 | 6.0× | 4/4 |
| Medium | 0.046 | 2.3× | 4.28 | 6.5× | 4/4 |
| Medium Plus | 0.056 | 2.2× | 4.79 | 1.7× | 4/4 |
| Fast | 0.104 | 1.5× | 7.45 | 1.5× | 4/4 |
| Circle | 0.035 | 1.7× | 1.34 | 3.0× | 4/4 |
| Square | 0.041 | 2.1× | 2.07 | 3.4× | 4/4 |

### Offline, one run, DAgger-like

- `train.py --training default` on `state-mlp/random-walk-fast-heavy_100hz-ref_load-reference-cable-direction_100-rounds_decay`: batch 256, 380k steps, learning rate 1e-3 to 1e-5 (10 min). The
  held-out loss was lowest around step 200k (0.0080) and rose again; the checkpoint is that best one.
- Checkpoint `logs/bc/default_single/best.pt`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.045 | 1.9× | 2.23 | 2.2× | 4/4 |
| Random figure 8 | 0.054 | 2.3× | 3.25 | 2.0× | 4/4 |
| Slow | 0.058 | 3.0× | 2.28 | 3.6× | 4/4 |
| Medium | 0.060 | 3.0× | 2.53 | 3.8× | 4/4 |
| Medium Plus | 0.066 | 2.5× | 4.02 | 1.4× | 4/4 |
| Fast | 0.129 | 1.8× | 7.73 | 1.6× | 4/4 |
| Circle | 0.069 | 3.5× | 1.90 | 4.3× | 4/4 |
| Square | 0.042 | 2.1× | 1.81 | 3.0× | 4/4 |

### Offline, four runs pooled, DAgger-like

- `train.py --training default` on the rollouts of four cable-direction runs together: 100 rounds, learning rate
  decay, Fast-heavy with decay, decay with gate 0.1 (4.1M training rows from 400 episodes, 11 min). The held-out loss
  fell to the end (0.0074).
- Checkpoint `logs/bc/default_pooled/best.pt`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.035 | 1.4× | 1.54 | 1.5× | 4/4 |
| Random figure 8 | 0.033 | 1.4× | 2.16 | 1.3× | 4/4 |
| Slow | 0.028 | 1.5× | 1.24 | 1.9× | 4/4 |
| Medium | 0.035 | 1.8× | 1.67 | 2.5× | 4/4 |
| Medium Plus | 0.040 | 1.5× | 3.54 | 1.2× | 4/4 |
| Fast | 0.108 | 1.5× | 8.73 | 1.8× | 4/4 |
| Circle | 0.028 | 1.4× | 0.93 | 2.1× | 4/4 |
| Square | 0.024 | 1.2× | 1.05 | 1.8× | 4/4 |

### Offline, four runs pooled, no cable input

- As four runs pooled, with `train.py --student load_reference`: the same flights and settings, the cable direction columns
  dropped (396 inputs, 11 min). Held-out loss 0.0077.
- Checkpoint `logs/bc/default_pooled_no-cable/best.pt`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.029 | 1.2× | 1.44 | 1.4× | 4/4 |
| Random figure 8 | 0.031 | 1.4× | 2.19 | 1.4× | 4/4 |
| Slow | 0.024 | 1.2× | 1.24 | 1.9× | 4/4 |
| Medium | 0.029 | 1.4× | 1.71 | 2.6× | 4/4 |
| Medium Plus | 0.031 | 1.2× | 3.73 | 1.3× | 4/4 |
| Fast | 0.091 | 1.3× | 7.25 | 1.5× | 2/4 (2 drone too low) |
| Circle | 0.023 | 1.2× | 0.79 | 1.8× | 4/4 |
| Square | 0.027 | 1.4× | 1.19 | 2.0× | 4/4 |

## Baselines

No student and no teacher, validate 4 flights per reference.

### Each drone flies its own reference

- Each drone flies its own drone reference (what D sees, with body rates added) with the same pilot: plain
  feedforward, no feedback on the payload.
- `validate.py --drone_reference`, branch `experiment/drone-reference-only` (worktree, uncommitted).
- Log: `logs/no_payload_position/drone-reference-baseline_validate.log`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random walk | 0.016 | 0.7× | 0.67 | 0.6× | 4/4 |
| Random figure 8 | 0.017 | 0.7× | 0.70 | 0.4× | 4/4 |
| Slow | 0.010 | 0.5× | 0.56 | 0.9× | 4/4 |
| Medium | 0.010 | 0.5× | 0.54 | 0.8× | 4/4 |
| Medium Plus | 0.025 | 1.0× | 0.84 | 0.3× | 4/4 |
| Fast | 0.057 | 0.8× | 1.92 | 0.4× | 4/4 |
| Circle | 0.009 | 0.5× | 0.55 | 1.3× | 4/4 |
| Square | 0.009 | 0.5× | 0.57 | 1.0× | 4/4 |

## Plant mismatch

All trained on the nominal plant, validated with the plant or the model changed, 4 flights per reference, seed 0.
`validate.py` flags: `--payload_mass_scale`, `--payload_com_offset` (sim payload, Isaac Lab startup events),
`--model_cable_length`, `--model_attach_offset` (the model the teacher and model-based inputs use; sim unchanged).
Batch: `.cache/plant_mismatch.sh`, `.cache/plant_mismatch_rest.sh` and `.cache/plant_mismatch_no_cable.sh`, logs in
`logs/plant_mismatch/`. A failed flight count shows as (completed/4). Drone reference only and open loop: 1 flight
per reference (`.cache/plant_mismatch_d_open_loop.sh`), so a failed flight shows as – with what ended it.

### Summary

Mean position error over the 8 references (m), and in brackets that mean over the controller's own nominal.
Bold: the more robust student per condition (fewest failed flights, then the smallest ratio). Failed flights out of
32 (out of 8 for the 1-flight columns) after a slash; a reference with no completed flight is left out of the mean.

| Condition | Teacher | Baseline (full state) | Feedforward (no payload state) | No cable input (no payload state, no cable measurement) | Drone reference only (no payload state, no cable), 1 flight | Open loop (no student), 1 flight |
|---|---|---|---|---|---|---|
| Nominal | 0.028 | 0.073 | 0.051 | 0.058 | 0.062 | 0.019 |
| Mass ×0.7 | 0.032 (×1.2) | 0.079 (×1.1) | 0.053 (×1.0) | **0.051 (×0.9)** | 0.068 (×1.1) | 0.017 (×0.9) |
| Mass ×1.3 | 0.027 (×1.0) | 0.075 (×1.0) | 0.060 (×1.2) | **0.057 (×1.0)** | 0.071 (×1.2) | 0.024 (×1.3) |
| Mass ×1.6 | 0.036 (×1.3) | 0.077 (×1.1) / 1 failed | 0.071 (×1.4) / 1 failed | **0.064 (×1.1)** | 0.063 (×1.0) / 1 failed | 0.032 (×1.6) |
| COM +3 cm | 0.136 (×4.9) | 0.085 (×1.2) | 0.076 (×1.5) | **0.066 (×1.1)** | 0.072 (×1.2) | 0.033 (×1.7) |
| Model cable 0.9 m | 0.207 (×7.5) / 2 failed | **0.073 (×1.0)** | 0.072 (×1.4) | 0.123 (×2.1) / 1 failed | 0.121 (×1.9) | 0.110 (×5.7) |
| Model cable 1.1 m | 0.197 (×7.1) | **0.073 (×1.0)** | 0.064 (×1.3) | 0.113 (×2.0) | 0.115 (×1.9) | 0.109 (×5.7) |
| Model attach +3 cm | 0.289 (×10.4) | **0.076 (×1.0)** | 0.099 (×2.0) | 0.095 (×1.6) | 0.086 (×1.4) | 0.060 (×3.1) |

### Teacher

- The current teacher (0.01 s sampling).

Pos (m):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.024 | 0.028 | 0.023 | 0.024 | 0.134 | 0.198 (2/4) | 0.200 | 0.287 |
| Random figure 8 | 0.023 | 0.029 | 0.021 | 0.022 | 0.134 | 0.205 | 0.199 | 0.288 |
| Slow | 0.019 | 0.024 | 0.017 | 0.017 | 0.130 | 0.196 | 0.199 | 0.282 |
| Medium | 0.020 | 0.025 | 0.018 | 0.018 | 0.131 | 0.198 | 0.199 | 0.283 |
| Medium Plus | 0.026 | 0.034 | 0.024 | 0.025 | 0.135 | 0.215 | 0.198 | 0.287 |
| Fast | 0.070 | 0.070 | 0.074 | 0.144 | 0.157 | 0.253 | 0.185 | 0.307 |
| Circle | 0.020 | 0.025 | 0.018 | 0.018 | 0.133 | 0.196 | 0.199 | 0.288 |
| Square | 0.020 | 0.025 | 0.018 | 0.018 | 0.133 | 0.196 | 0.199 | 0.288 |

Att (°):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 1.0 | 1.1 | 1.1 | 1.2 | 1.3 | 1.8 (2/4) | 1.2 | 1.6 |
| Random figure 8 | 1.6 | 1.6 | 1.6 | 1.7 | 1.8 | 3.2 | 1.4 | 2.2 |
| Slow | 0.6 | 1.1 | 0.6 | 0.7 | 1.0 | 1.0 | 1.1 | 1.5 |
| Medium | 0.7 | 1.1 | 0.7 | 0.9 | 1.1 | 1.6 | 1.2 | 1.6 |
| Medium Plus | 2.9 | 2.9 | 3.0 | 3.2 | 3.1 | 5.3 | 1.7 | 3.4 |
| Fast | 5.0 | 5.0 | 5.0 | 13.0 | 5.1 | 8.5 | 2.8 | 5.4 |
| Circle | 0.4 | 0.5 | 0.7 | 0.7 | 0.9 | 0.8 | 0.9 | 1.2 |
| Square | 0.6 | 0.4 | 0.5 | 0.6 | 0.8 | 1.1 | 1.0 | 1.3 |


### Medium-to-Fast random walk

- The full-state student. Branch `experiment/random-trajectories`.

Pos (m):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.050 | 0.058 | 0.058 | 0.061 | 0.064 | 0.050 | 0.050 | 0.052 |
| Random figure 8 | 0.062 | 0.065 | 0.061 | 0.064 | 0.067 | 0.062 | 0.062 | 0.064 |
| Slow | 0.044 | 0.047 | 0.042 | 0.046 | 0.058 | 0.044 | 0.044 | 0.047 |
| Medium | 0.062 | 0.070 | 0.066 | 0.069 | 0.073 | 0.062 | 0.062 | 0.067 |
| Medium Plus | 0.092 | 0.103 | 0.092 | 0.091 | 0.100 | 0.092 | 0.092 | 0.093 |
| Fast | 0.220 | 0.229 | 0.217 | 0.217 (3/4) | 0.219 | 0.220 | 0.220 | 0.220 |
| Circle | 0.027 | 0.033 | 0.026 | 0.029 | 0.041 | 0.027 | 0.027 | 0.032 |
| Square | 0.029 | 0.032 | 0.037 | 0.042 | 0.059 | 0.029 | 0.029 | 0.032 |

Att (°):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 2.4 | 2.4 | 2.5 | 2.6 | 2.4 | 2.4 | 2.4 | 2.2 |
| Random figure 8 | 3.0 | 2.8 | 2.9 | 3.1 | 2.9 | 3.0 | 3.0 | 3.0 |
| Slow | 2.0 | 2.1 | 1.9 | 1.9 | 1.9 | 2.0 | 2.0 | 1.9 |
| Medium | 2.3 | 2.4 | 2.2 | 2.2 | 2.3 | 2.3 | 2.3 | 2.3 |
| Medium Plus | 3.8 | 3.9 | 4.0 | 4.1 | 3.9 | 3.8 | 3.8 | 3.8 |
| Fast | 8.7 | 9.9 | 9.8 | 10.4 (3/4) | 9.7 | 8.7 | 8.7 | 8.7 |
| Circle | 1.7 | 1.7 | 1.8 | 1.9 | 1.7 | 1.7 | 1.7 | 1.6 |
| Square | 1.4 | 1.5 | 1.3 | 1.3 | 1.1 | 1.4 | 1.4 | 1.2 |


### Medium-to-Fast random walk, drone reference as input only

- No payload state, drone reference as input. Branch `experiment/feedforward-input`.

Pos (m):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.048 | 0.042 | 0.047 | 0.050 | 0.066 | 0.062 | 0.057 | 0.095 |
| Random figure 8 | 0.048 | 0.046 | 0.050 | 0.054 | 0.067 | 0.069 | 0.061 | 0.099 |
| Slow | 0.029 | 0.029 | 0.033 | 0.035 | 0.061 | 0.047 | 0.045 | 0.090 |
| Medium | 0.045 | 0.057 | 0.058 | 0.059 | 0.077 | 0.060 | 0.058 | 0.095 |
| Medium Plus | 0.060 | 0.051 | 0.069 | 0.080 | 0.076 | 0.088 | 0.071 | 0.103 |
| Fast | 0.122 | 0.140 | 0.158 | 0.219 (3/4) | 0.154 | 0.151 | 0.139 | 0.147 |
| Circle | 0.025 | 0.034 | 0.041 | 0.045 | 0.067 | 0.049 | 0.039 | 0.081 |
| Square | 0.032 | 0.022 | 0.024 | 0.026 | 0.039 | 0.053 | 0.044 | 0.086 |

Att (°):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 2.0 | 2.2 | 2.3 | 2.4 | 2.2 | 2.3 | 2.2 | 2.2 |
| Random figure 8 | 2.9 | 2.9 | 3.2 | 3.4 | 3.0 | 3.2 | 3.2 | 3.2 |
| Slow | 1.4 | 1.7 | 1.6 | 1.8 | 1.6 | 1.7 | 1.8 | 1.7 |
| Medium | 2.0 | 2.7 | 2.5 | 2.7 | 2.4 | 2.5 | 2.2 | 2.3 |
| Medium Plus | 4.4 | 4.3 | 4.8 | 5.2 | 4.7 | 5.1 | 4.0 | 4.7 |
| Fast | 9.5 | 8.2 | 8.6 | 17.3 (3/4) | 8.4 | 10.2 | 8.8 | 9.8 |
| Circle | 1.1 | 1.2 | 1.5 | 1.7 | 1.4 | 1.5 | 1.1 | 1.1 |
| Square | 1.2 | 0.9 | 1.1 | 1.3 | 0.9 | 1.7 | 1.5 | 1.5 |


### Medium-to-Fast random walk, drone reference as input only, no cable input

- No payload state and no cable measurement. Branch `experiment/no-cable-input` (worktree, uncommitted).

Pos (m):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.043 | 0.040 | 0.048 | 0.053 | 0.056 | 0.115 (3/4) | 0.100 | 0.081 |
| Random figure 8 | 0.046 | 0.044 | 0.052 | 0.058 | 0.060 | 0.117 | 0.103 | 0.081 |
| Slow | 0.036 | 0.031 | 0.040 | 0.044 | 0.051 | 0.113 | 0.096 | 0.080 |
| Medium | 0.042 | 0.045 | 0.050 | 0.053 | 0.059 | 0.109 | 0.106 | 0.082 |
| Medium Plus | 0.055 | 0.054 | 0.057 | 0.063 | 0.064 | 0.117 | 0.110 | 0.086 |
| Fast | 0.161 | 0.125 | 0.126 | 0.145 | 0.128 | 0.182 | 0.199 | 0.178 |
| Circle | 0.043 | 0.030 | 0.039 | 0.043 | 0.047 | 0.118 | 0.096 | 0.095 |
| Square | 0.036 | 0.036 | 0.047 | 0.052 | 0.062 | 0.115 | 0.096 | 0.078 |

Att (°):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 2.1 | 2.4 | 2.6 | 2.9 | 2.6 | 2.6 (3/4) | 2.0 | 3.5 |
| Random figure 8 | 3.4 | 3.0 | 3.3 | 3.6 | 3.4 | 3.4 | 3.3 | 4.5 |
| Slow | 1.4 | 1.7 | 1.8 | 2.2 | 2.0 | 1.4 | 1.5 | 2.8 |
| Medium | 2.1 | 2.4 | 2.5 | 2.9 | 2.7 | 2.3 | 2.0 | 3.1 |
| Medium Plus | 4.7 | 4.7 | 4.8 | 4.8 | 4.8 | 4.7 | 4.7 | 5.2 |
| Fast | 7.6 | 8.5 | 8.3 | 11.8 | 8.4 | 7.9 | 7.5 | 8.4 |
| Circle | 1.5 | 1.4 | 2.0 | 2.5 | 2.2 | 1.4 | 1.6 | 2.8 |
| Square | 1.5 | 1.5 | 1.7 | 2.2 | 1.8 | 1.4 | 1.6 | 3.2 |


### Medium-to-Fast random walk, full state, residual on each drone's reference

- Full state, residual label on the drone reference. Branch `experiment/full-state-residual`.

Pos (m):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.063 | 0.058 | 0.060 | 0.062 | 0.081 | 0.151 (3/4) | 0.149 | 0.140 |
| Random figure 8 | 0.056 | 0.051 | 0.052 | 0.055 | 0.071 | 0.150 | 0.145 | 0.120 |
| Slow | 0.062 | 0.059 | 0.061 | 0.063 | 0.089 | 0.153 | 0.148 | 0.146 |
| Medium | 0.066 | 0.061 | 0.065 | 0.068 | 0.090 | 0.155 | 0.151 | 0.153 |
| Medium Plus | 0.069 | 0.066 | 0.070 | 0.075 | 0.091 | 0.148 | 0.151 | 0.149 |
| Fast | 0.118 | 0.106 | 0.116 | – (0/4) | 0.125 | 0.160 | 0.184 | 0.183 |
| Circle | 0.059 | 0.047 | 0.047 | 0.049 | 0.065 | 0.152 | 0.145 | 0.133 |
| Square | 0.058 | 0.073 | 0.075 | 0.077 | 0.109 | 0.147 | 0.152 | 0.145 |

Att (°):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 1.5 | 1.3 | 1.5 | 1.6 | 1.4 | 2.2 (3/4) | 1.4 | 1.6 |
| Random figure 8 | 2.1 | 2.0 | 2.2 | 2.4 | 2.2 | 2.4 | 2.1 | 2.4 |
| Slow | 1.1 | 1.2 | 1.3 | 1.4 | 1.3 | 1.3 | 1.3 | 1.5 |
| Medium | 1.2 | 1.4 | 1.5 | 1.6 | 1.5 | 1.6 | 1.5 | 1.4 |
| Medium Plus | 3.4 | 3.4 | 3.6 | 3.7 | 3.7 | 3.8 | 3.1 | 3.7 |
| Fast | 6.3 | 6.0 | 6.4 | – (0/4) | 6.4 | 7.0 | 5.9 | 6.6 |
| Circle | 0.9 | 0.9 | 1.1 | 1.3 | 1.1 | 1.2 | 1.1 | 1.1 |
| Square | 0.9 | 0.7 | 1.1 | 1.2 | 1.0 | 1.4 | 0.9 | 1.0 |


### Medium-to-Fast random walk, drone reference only

- No payload state and no cable at all: the drone reference, the drone's own state and its attach point.
  Branch `experiment/drone-reference-only` (worktree, uncommitted).
- 1 flight per reference. Batch `.cache/plant_mismatch_d_open_loop.sh` (and `_rest.sh` after a stop).

Pos (m):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.075 | 0.072 | 0.085 | 0.095 | 0.080 | 0.127 | 0.120 | 0.094 |
| Random figure 8 | 0.064 | 0.051 | 0.047 | 0.052 | 0.050 | 0.115 | 0.113 | 0.090 |
| Slow | 0.034 | 0.042 | 0.042 | 0.047 | 0.045 | 0.105 | 0.097 | 0.053 |
| Medium | 0.051 | 0.059 | 0.055 | 0.059 | 0.064 | 0.111 | 0.106 | 0.069 |
| Medium Plus | 0.082 | 0.086 | 0.095 | 0.103 | 0.092 | 0.138 | 0.120 | 0.099 |
| Fast | 0.126 | 0.158 | 0.178 | – (drone too low) | 0.163 | 0.166 | 0.168 | 0.152 |
| Circle | 0.026 | 0.045 | 0.041 | 0.047 | 0.054 | 0.100 | 0.096 | 0.052 |
| Square | 0.037 | 0.031 | 0.029 | 0.037 | 0.027 | 0.103 | 0.099 | 0.077 |

Att (°):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 4.5 | 4.2 | 5.6 | 6.3 | 5.1 | 4.5 | 4.6 | 4.9 |
| Random figure 8 | 3.6 | 3.1 | 4.5 | 5.6 | 4.1 | 3.4 | 3.8 | 4.7 |
| Slow | 3.1 | 3.1 | 3.9 | 4.8 | 3.7 | 3.0 | 3.4 | 3.9 |
| Medium | 4.4 | 3.2 | 4.7 | 5.5 | 4.3 | 4.2 | 4.5 | 5.0 |
| Medium Plus | 7.2 | 6.1 | 8.1 | 9.1 | 7.5 | 7.4 | 7.1 | 7.7 |
| Fast | 8.6 | 9.1 | 10.6 | – (drone too low) | 9.7 | 8.6 | 8.7 | 8.8 |
| Circle | 1.5 | 2.4 | 2.5 | 3.5 | 2.3 | 1.4 | 1.7 | 3.3 |
| Square | 2.2 | 1.6 | 2.6 | 3.7 | 2.3 | 2.3 | 2.1 | 3.1 |

### Open loop, each drone flies its own reference

- No student and no teacher: each drone flies its own drone reference with the same pilot
  (`validate.py --drone_reference`). The reference is built with the model, so the model's mismatches reach it.
  Worktree `.cache/worktrees/drone-reference-only`.
- 1 flight per reference. Same batch as D.

Pos (m):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.021 | 0.020 | 0.027 | 0.039 | 0.034 | 0.110 | 0.110 | 0.058 |
| Random figure 8 | 0.012 | 0.010 | 0.013 | 0.016 | 0.028 | 0.106 | 0.107 | 0.056 |
| Slow | 0.010 | 0.010 | 0.013 | 0.016 | 0.028 | 0.105 | 0.107 | 0.056 |
| Medium | 0.010 | 0.009 | 0.011 | 0.014 | 0.027 | 0.105 | 0.107 | 0.056 |
| Medium Plus | 0.025 | 0.022 | 0.033 | 0.043 | 0.036 | 0.112 | 0.111 | 0.061 |
| Fast | 0.058 | 0.044 | 0.075 | 0.099 | 0.062 | 0.133 | 0.118 | 0.081 |
| Circle | 0.009 | 0.009 | 0.011 | 0.013 | 0.026 | 0.105 | 0.107 | 0.056 |
| Square | 0.010 | 0.009 | 0.011 | 0.013 | 0.026 | 0.106 | 0.107 | 0.056 |

Att (°):

| Reference | Nominal | Mass ×0.7 | Mass ×1.3 | Mass ×1.6 | COM +3 cm | Model cable 0.9 m | Model cable 1.1 m | Model attach +3 cm |
|---|---|---|---|---|---|---|---|---|
| Random walk | 0.8 | 1.0 | 1.0 | 1.5 | 1.7 | 1.6 | 1.3 | 1.7 |
| Random figure 8 | 0.6 | 0.6 | 0.6 | 0.7 | 1.5 | 1.0 | 0.6 | 1.6 |
| Slow | 0.5 | 0.7 | 0.7 | 0.9 | 1.5 | 0.9 | 0.5 | 1.6 |
| Medium | 0.5 | 0.6 | 0.6 | 0.8 | 1.5 | 0.9 | 0.6 | 1.6 |
| Medium Plus | 0.8 | 0.9 | 1.0 | 1.3 | 1.7 | 1.2 | 1.3 | 1.8 |
| Fast | 1.9 | 1.9 | 2.3 | 3.0 | 2.3 | 2.2 | 2.4 | 2.4 |
| Circle | 0.5 | 0.6 | 0.7 | 0.8 | 1.5 | 0.8 | 0.5 | 1.6 |
| Square | 0.6 | 0.5 | 0.6 | 0.7 | 1.5 | 0.9 | 0.6 | 1.6 |

## Disturbances

All trained on the nominal plant and without disturbances, validated with them, 1 flight per reference, seed 0.
`validate.py` flags (develop, uncommitted, ported to the worktrees):
- `--payload_force N --payload_torque Nm`: Isaac Lab's `apply_external_force_torque` as an interval event on the
  payload, a force and torque drawn per axis between minus and plus the value, held for 1 to 3 s, then redrawn.
  Here with 0.05 N m of torque.
- `--noise_scale`: each measured student input's configured noise and the pilot's measurement noise (3 mm, 0.01,
  1 cm/s, 0.02 rad/s, 0.05, 0.05), times this, white.
- The action term now puts the rotor forces on the instantaneous wrench composer, so the gusts reach the sim. Open
  loop's and D's nominal runs are byte-identical to before that change.

Batch: `.cache/disturbances.sh`, logs in `logs/disturbances/`.

### Summary

Mean position error / mean attitude error over the 8 references. Failed flights out of 8 in brackets; a
reference with no completed flight is left out of the mean.

| Controller | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Teacher | 0.028 m / 1.6° | 0.308 m / 4.8° | 0.645 m / 7.6° | 0.040 m / 2.3° | 0.636 m / 7.8° |
| Open loop | 0.019 m / 0.8° | 0.125 m / 6.7° | 0.229 m / 12.4° | 0.027 m / 1.6° | 0.248 m / 13.1° |
| Baseline (full state) | 0.074 m / 3.2° | 0.179 m / 4.7° | 0.322 m / 7.1° | 0.078 m / 3.5° | 0.328 m / 7.6° |
| No cable input | 0.059 m / 3.2° | 0.135 m / 6.2° | 0.249 m / 10.6° | 0.064 m / 3.7° | 0.260 m / 11.6° |
| Drone reference only | 0.062 m / 4.4° | 0.143 m / 6.7° | 0.243 m / 10.2° | 0.069 m / 5.3° | 0.236 m / 10.6° (1 failed) |

### Teacher

- The current teacher, from the main checkout (develop).

Pos (m):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 0.030 | 0.271 | 0.566 | 0.038 | 0.754 |
| Random figure 8 | 0.020 | 0.324 | 0.685 | 0.035 | 0.464 |
| Slow | 0.019 | 0.338 | 0.748 | 0.035 | 0.686 |
| Medium | 0.020 | 0.283 | 0.561 | 0.033 | 0.701 |
| Medium Plus | 0.026 | 0.315 | 0.652 | 0.035 | 0.599 |
| Fast | 0.070 | 0.285 | 0.583 | 0.077 | 0.689 |
| Circle | 0.020 | 0.337 | 0.718 | 0.031 | 0.564 |
| Square | 0.020 | 0.308 | 0.647 | 0.034 | 0.634 |

Att (°):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 1.6 | 5.0 | 9.4 | 2.0 | 8.5 |
| Random figure 8 | 0.9 | 4.3 | 6.5 | 1.7 | 6.0 |
| Slow | 0.6 | 4.5 | 7.1 | 1.5 | 8.2 |
| Medium | 0.7 | 3.9 | 6.4 | 1.3 | 8.1 |
| Medium Plus | 2.9 | 4.9 | 7.5 | 3.4 | 7.9 |
| Fast | 5.0 | 7.1 | 9.4 | 5.4 | 10.8 |
| Circle | 0.4 | 4.7 | 7.6 | 1.6 | 6.6 |
| Square | 0.8 | 4.1 | 6.6 | 1.6 | 6.6 |

### Open loop, each drone flies its own reference

- `--drone_reference`, worktree `.cache/worktrees/drone-reference-only`.

Pos (m):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 0.021 | 0.123 | 0.252 | 0.025 | 0.214 |
| Random figure 8 | 0.012 | 0.144 | 0.247 | 0.020 | 0.269 |
| Slow | 0.010 | 0.116 | 0.228 | 0.022 | 0.263 |
| Medium | 0.010 | 0.115 | 0.202 | 0.017 | 0.195 |
| Medium Plus | 0.025 | 0.119 | 0.218 | 0.030 | 0.219 |
| Fast | 0.058 | 0.138 | 0.246 | 0.063 | 0.305 |
| Circle | 0.009 | 0.134 | 0.242 | 0.018 | 0.285 |
| Square | 0.010 | 0.109 | 0.197 | 0.021 | 0.231 |

Att (°):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 0.8 | 6.9 | 13.8 | 1.6 | 11.1 |
| Random figure 8 | 0.6 | 7.0 | 12.3 | 1.4 | 13.9 |
| Slow | 0.5 | 6.8 | 13.3 | 1.4 | 14.3 |
| Medium | 0.5 | 6.7 | 11.8 | 1.4 | 11.4 |
| Medium Plus | 0.8 | 6.2 | 11.7 | 1.5 | 12.0 |
| Fast | 1.9 | 6.3 | 11.3 | 2.5 | 14.4 |
| Circle | 0.5 | 7.0 | 12.7 | 1.4 | 15.8 |
| Square | 0.6 | 6.7 | 12.0 | 1.4 | 11.7 |

### Medium-to-Fast random walk

- The full-state student (A). Worktree `.cache/worktrees/random-trajectories` with the MPC package at 243caaa,
  as on 2026-10-20. Nominal and 4 N from `.cache/disturbance_check_a.sh`.

Pos (m):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 0.069 | 0.188 | 0.354 | 0.072 | 0.353 |
| Random figure 8 | 0.054 | 0.158 | 0.319 | 0.062 | 0.271 |
| Slow | 0.047 | 0.162 | 0.322 | 0.052 | 0.332 |
| Medium | 0.065 | 0.161 | 0.286 | 0.068 | 0.336 |
| Medium Plus | 0.083 | 0.174 | 0.304 | 0.086 | 0.304 |
| Fast | 0.215 | 0.282 | 0.382 | 0.203 | 0.343 |
| Circle | 0.030 | 0.158 | 0.316 | 0.046 | 0.406 |
| Square | 0.029 | 0.149 | 0.289 | 0.036 | 0.281 |

Att (°):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 3.0 | 4.8 | 8.0 | 3.3 | 6.9 |
| Random figure 8 | 2.3 | 3.4 | 6.4 | 2.5 | 6.2 |
| Slow | 2.0 | 3.8 | 6.6 | 2.6 | 7.3 |
| Medium | 2.4 | 3.5 | 6.0 | 2.8 | 6.6 |
| Medium Plus | 4.2 | 4.5 | 6.0 | 4.5 | 7.0 |
| Fast | 8.4 | 10.8 | 12.7 | 8.3 | 12.7 |
| Circle | 1.6 | 3.5 | 5.8 | 2.0 | 7.7 |
| Square | 1.7 | 3.3 | 5.5 | 2.3 | 6.0 |

### Medium-to-Fast random walk, drone reference as input only, no cable input

- C. Worktree `.cache/worktrees/no-cable-input`.

Pos (m):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 0.053 | 0.147 | 0.290 | 0.054 | 0.228 |
| Random figure 8 | 0.035 | 0.135 | 0.258 | 0.042 | 0.256 |
| Slow | 0.034 | 0.129 | 0.258 | 0.046 | 0.286 |
| Medium | 0.046 | 0.123 | 0.221 | 0.046 | 0.236 |
| Medium Plus | 0.051 | 0.126 | 0.236 | 0.056 | 0.220 |
| Fast | 0.186 | 0.172 | 0.256 | 0.192 | 0.322 |
| Circle | 0.039 | 0.129 | 0.251 | 0.043 | 0.285 |
| Square | 0.025 | 0.116 | 0.220 | 0.037 | 0.246 |

Att (°):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 3.1 | 6.5 | 12.3 | 3.4 | 10.6 |
| Random figure 8 | 2.4 | 5.5 | 9.9 | 2.6 | 11.4 |
| Slow | 1.2 | 5.3 | 10.0 | 2.1 | 12.4 |
| Medium | 2.1 | 6.3 | 10.6 | 2.5 | 9.4 |
| Medium Plus | 5.1 | 6.7 | 10.3 | 5.4 | 11.6 |
| Fast | 8.3 | 9.1 | 12.1 | 8.8 | 14.9 |
| Circle | 1.4 | 5.3 | 10.0 | 2.2 | 12.2 |
| Square | 2.0 | 5.1 | 9.2 | 2.5 | 10.1 |

### Medium-to-Fast random walk, drone reference only

- D. Worktree `.cache/worktrees/drone-reference-only`.

Pos (m):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 0.075 | 0.142 | 0.264 | 0.075 | 0.228 |
| Random figure 8 | 0.064 | 0.146 | 0.253 | 0.065 | 0.248 |
| Slow | 0.034 | 0.138 | 0.260 | 0.046 | 0.263 |
| Medium | 0.051 | 0.132 | 0.222 | 0.054 | 0.220 |
| Medium Plus | 0.082 | 0.142 | 0.232 | 0.084 | 0.204 |
| Fast | 0.126 | 0.202 | 0.265 | 0.134 | – (cable angle at drone too large) |
| Circle | 0.026 | 0.127 | 0.237 | 0.039 | 0.261 |
| Square | 0.037 | 0.118 | 0.213 | 0.051 | 0.227 |

Att (°):

| Reference | Nominal | Gusts 2 N | Gusts 4 N | Noise ×10 | Gusts 4 N + noise ×10 |
|---|---|---|---|---|---|
| Random walk | 4.5 | 6.4 | 10.7 | 5.3 | 9.1 |
| Random figure 8 | 3.6 | 6.4 | 10.1 | 4.2 | 11.5 |
| Slow | 3.1 | 5.6 | 9.9 | 4.9 | 13.0 |
| Medium | 4.4 | 7.0 | 10.8 | 5.3 | 9.7 |
| Medium Plus | 7.2 | 8.6 | 11.3 | 7.3 | 12.3 |
| Fast | 8.6 | 10.6 | 12.9 | 9.0 | – (cable angle at drone too large) |
| Circle | 1.5 | 4.7 | 8.4 | 2.9 | 10.8 |
| Square | 2.2 | 4.3 | 7.6 | 3.1 | 8.1 |

## Robustness, the sim changed

The Medium-to-Fast random walk students (no payload velocity at round 24, the 50-round students at round 49), open loop and
the current teacher, validate 4 flights per reference, seed 0. Only the sim changes: every controller and every model-based
input keeps the nominal rig, and the teacher is never told about the wind. Batch `.cache/robustness.sh`, logs in
`logs/robustness/`.

- Gusts (`--gust_speed`, built on branch `experiment/wind-gust`, now `experiments` 28d9bd2): two gusts of 1 s at 13 s and 27 s, each from a random horizontal
  direction, on the payload (air drag, 0.08 m² side on) and on every drone (rotor drag, 0.435 N per m/s). 5 m/s, about 10
  knots: 1.3 N on the payload, 2.2 N on each drone. 7.5 m/s: 2.9 N and 3.3 N.
- Plant (built on branch `experiment/plant-mismatch`, now `experiments` 28d9bd2): payload mass ×2 (1.4 to 2.8 kg); payload COM +3 cm along x; the thesis's ropes
  and attach points, attach points moved +3 cm x, −3 cm y and +3 cm y, ropes 1 and 2 +3.5 and −3.5 cm
  (`--attach_point_offsets`, `--cable_length_offsets`, the rope anchors moved in the USD before the sim starts).
- Open loop: `--drone_reference`, each drone flies its own reference with the pilot.

### Summary

Mean position error over the seven references other than Fast (m), in brackets that mean over the controller's own
nominal, and failed flights out of 32 after a slash (all on Fast). Bold: the best per condition.

| Controller | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Teacher | 0.022 | **0.101** (×4.6) | **0.169** (×7.8) | **0.024** (×1.1) / 4 | 0.133 (×6.1) | 0.197 (×9.1) |
| Open loop | **0.014** | 0.122 (×8.7) | 0.183 (×13.2) | 0.029 (×2.1) / 4 | **0.029** (×2.1) | **0.051** (×3.6) |
| No payload velocity | 0.053 | 0.121 (×2.3) | 0.188 (×3.5) | 0.068 (×1.3) / 4 | 0.064 (×1.2) | 0.052 (×1.0) |
| Payload reference only | 0.084 / 4 | 0.131 (×1.6) / 4 | 0.184 (×2.2) / 4 | 0.102 (×1.2) / 4 | 0.093 (×1.1) / 4 | 0.089 (×1.1) / 4 |
| + cable direction | 0.074 / 2 | 0.124 (×1.7) / 1 | 0.176 (×2.4) / 1 | 0.086 (×1.2) / 4 | 0.090 (×1.2) / 2 | 0.090 (×1.2) / 2 |
| + cable force | 0.060 / 4 | 0.116 (×1.9) / 4 | 0.180 (×3.0) / 4 | 0.224 (×3.7) / 4 | 0.073 (×1.2) / 4 | 0.075 (×1.2) / 4 |

Mean attitude error over the same seven references (°).

| Controller | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Teacher | 1.13 | **3.76** | **5.48** | 1.52 | **1.44** | 24.61 |
| Open loop | **0.63** | 5.28 | 8.19 | **1.18** | 1.55 | 6.55 |
| No payload velocity | 2.45 | 4.06 | 5.84 | 3.13 | 2.62 | **2.80** |
| Payload reference only | 3.72 | 5.11 | 6.58 | 4.92 | 4.02 | 7.35 |
| + cable direction | 3.59 | 4.81 | 6.33 | 4.14 | 3.86 | 7.08 |
| + cable force | 3.48 | 5.01 | 6.72 | 9.62 | 4.10 | 5.63 |

Fast, position error (m) and completed flights.

| Controller | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Teacher | 0.070 | 0.106 | 0.156 | 0/4 | 0.157 | 0.195 |
| Open loop | 0.057 | 0.119 | 0.177 | 0/4 | 0.062 | 0.077 |
| No payload velocity | 0.279 | 0.279 | 0.310 | 0/4 | 0.239 | 0.292 |
| Payload reference only | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 |
| + cable direction | 0.228 (2/4) | 0.259 (3/4) | 0.301 (3/4) | 0/4 | 0.207 (2/4) | 0.238 (2/4) |
| + cable force | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 |

Largest error per flight under the gusts, mean over the seven references other than Fast: position (m) / attitude (°).

| Controller | Nominal | Gusts 5 m/s | Gusts 7.5 m/s |
|---|---|---|---|
| Teacher | 0.034 / 3.5 | 0.489 / 18.8 | 0.851 / 29.8 |
| Open loop | 0.059 / 3.6 | 0.463 / 21.5 | 0.694 / 33.4 |
| No payload velocity | 0.106 / 5.5 | 0.532 / 15.3 | 0.840 / 24.2 |
| Payload reference only | 0.146 / 7.5 | 0.556 / 17.7 | 0.846 / 27.7 |
| + cable direction | 0.136 / 7.3 | 0.518 / 17.1 | 0.814 / 27.2 |
| + cable force | 0.127 / 6.5 | 0.494 / 18.7 | 0.800 / 29.6 |

### Teacher

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.024 | 0.100 | 0.166 | 0.027 | 0.134 | 0.195 |
| Random figure 8 | 0.023 | 0.101 | 0.168 | 0.027 | 0.134 | 0.194 |
| Slow | 0.019 | 0.100 | 0.168 | 0.019 | 0.130 | 0.201 |
| Medium | 0.020 | 0.103 | 0.172 | 0.020 | 0.131 | 0.200 |
| Medium Plus | 0.026 | 0.093 | 0.158 | 0.033 | 0.135 | 0.198 |
| Fast | 0.070 | 0.106 | 0.156 | 0/4 | 0.157 | 0.195 |
| Circle | 0.020 | 0.104 | 0.174 | 0.020 | 0.133 | 0.196 |
| Square | 0.020 | 0.104 | 0.176 | 0.019 | 0.133 | 0.196 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 1.03 | 3.68 | 5.30 | 1.33 | 1.30 | 24.8 |
| Random figure 8 | 1.62 | 3.91 | 5.51 | 2.05 | 1.81 | 24.7 |
| Slow | 0.64 | 3.50 | 5.20 | 1.06 | 1.04 | 24.7 |
| Medium | 0.66 | 3.57 | 5.23 | 1.16 | 1.13 | 24.6 |
| Medium Plus | 2.89 | 4.57 | 6.01 | 3.49 | 3.06 | 24.1 |
| Fast | 4.96 | 5.63 | 6.55 | 0/4 | 5.11 | 22.9 |
| Circle | 0.44 | 3.37 | 5.20 | 0.82 | 0.91 | 24.7 |
| Square | 0.60 | 3.73 | 5.91 | 0.70 | 0.84 | 24.7 |

Failed flights ended by: drone too low 3, payload too low 1.

### Open loop, each drone flies its own reference

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.016 | 0.120 | 0.180 | 0.036 | 0.031 | 0.050 |
| Random figure 8 | 0.017 | 0.123 | 0.185 | 0.035 | 0.031 | 0.051 |
| Slow | 0.010 | 0.120 | 0.182 | 0.019 | 0.028 | 0.050 |
| Medium | 0.010 | 0.123 | 0.184 | 0.018 | 0.027 | 0.050 |
| Medium Plus | 0.025 | 0.120 | 0.179 | 0.061 | 0.036 | 0.055 |
| Fast | 0.057 | 0.119 | 0.177 | 0/4 | 0.062 | 0.077 |
| Circle | 0.009 | 0.128 | 0.192 | 0.017 | 0.026 | 0.049 |
| Square | 0.009 | 0.117 | 0.177 | 0.017 | 0.026 | 0.049 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.67 | 5.46 | 8.52 | 1.35 | 1.59 | 6.55 |
| Random figure 8 | 0.70 | 5.23 | 8.06 | 1.26 | 1.57 | 6.53 |
| Slow | 0.56 | 5.51 | 8.55 | 1.11 | 1.52 | 6.54 |
| Medium | 0.54 | 5.36 | 8.30 | 1.11 | 1.51 | 6.57 |
| Medium Plus | 0.84 | 4.86 | 7.51 | 1.78 | 1.68 | 6.58 |
| Fast | 1.92 | 4.56 | 7.24 | 0/4 | 2.28 | 6.83 |
| Circle | 0.55 | 5.09 | 7.82 | 0.86 | 1.51 | 6.54 |
| Square | 0.57 | 5.48 | 8.59 | 0.77 | 1.50 | 6.55 |

Failed flights ended by: cable angle 2, drone too low 2.

### Medium-to-Fast random walk, no payload velocity

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.060 | 0.122 | 0.189 | 0.072 | 0.064 | 0.057 |
| Random figure 8 | 0.065 | 0.126 | 0.194 | 0.071 | 0.074 | 0.065 |
| Slow | 0.037 | 0.108 | 0.174 | 0.049 | 0.049 | 0.033 |
| Medium | 0.063 | 0.132 | 0.194 | 0.087 | 0.080 | 0.059 |
| Medium Plus | 0.081 | 0.125 | 0.181 | 0.092 | 0.082 | 0.082 |
| Fast | 0.279 | 0.279 | 0.310 | 0/4 | 0.239 | 0.292 |
| Circle | 0.031 | 0.118 | 0.193 | 0.065 | 0.064 | 0.038 |
| Square | 0.036 | 0.114 | 0.190 | 0.040 | 0.035 | 0.034 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 2.21 | 3.89 | 5.69 | 2.79 | 2.40 | 2.42 |
| Random figure 8 | 3.20 | 4.49 | 6.12 | 3.77 | 3.47 | 3.43 |
| Slow | 2.00 | 3.79 | 5.74 | 2.98 | 2.19 | 2.59 |
| Medium | 2.52 | 4.46 | 6.50 | 3.54 | 2.95 | 2.84 |
| Medium Plus | 4.53 | 5.39 | 6.67 | 5.25 | 4.65 | 4.81 |
| Fast | 13.4 | 13.3 | 14.1 | 0/4 | 12.5 | 13.9 |
| Circle | 1.27 | 2.99 | 4.72 | 1.87 | 1.43 | 1.72 |
| Square | 1.45 | 3.43 | 5.42 | 1.71 | 1.27 | 1.82 |

Failed flights ended by: drone too low 4.

### Medium-to-Fast random walk, payload reference only, 50 rounds

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.076 | 0.126 | 0.177 | 0.090 | 0.086 | 0.093 |
| Random figure 8 | 0.087 | 0.139 | 0.194 | 0.114 | 0.093 | 0.092 |
| Slow | 0.080 | 0.127 | 0.174 | 0.094 | 0.085 | 0.083 |
| Medium | 0.105 | 0.135 | 0.191 | 0.114 | 0.105 | 0.110 |
| Medium Plus | 0.100 | 0.123 | 0.173 | 0.128 | 0.103 | 0.111 |
| Fast | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 |
| Circle | 0.060 | 0.119 | 0.176 | 0.074 | 0.066 | 0.056 |
| Square | 0.081 | 0.145 | 0.200 | 0.100 | 0.114 | 0.078 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 3.01 | 4.97 | 6.86 | 4.77 | 3.72 | 6.71 |
| Random figure 8 | 4.06 | 5.84 | 7.44 | 5.19 | 4.16 | 7.29 |
| Slow | 3.80 | 4.56 | 5.77 | 4.76 | 3.82 | 7.85 |
| Medium | 3.73 | 5.66 | 7.09 | 4.88 | 4.17 | 7.37 |
| Medium Plus | 6.15 | 7.19 | 8.06 | 6.67 | 6.42 | 8.50 |
| Fast | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 |
| Circle | 2.82 | 3.93 | 5.27 | 3.36 | 2.53 | 6.94 |
| Square | 2.48 | 3.65 | 5.54 | 4.80 | 3.35 | 6.79 |

Failed flights ended by: cables too close 1, drone too low 4, drones too close 19.

### Medium-to-Fast random walk, payload reference and cable direction, 50 rounds

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.088 | 0.120 | 0.170 | 0.103 | 0.098 | 0.100 |
| Random figure 8 | 0.074 | 0.134 | 0.183 | 0.092 | 0.098 | 0.086 |
| Slow | 0.070 | 0.122 | 0.172 | 0.078 | 0.088 | 0.090 |
| Medium | 0.072 | 0.121 | 0.173 | 0.084 | 0.094 | 0.083 |
| Medium Plus | 0.088 | 0.131 | 0.179 | 0.099 | 0.096 | 0.097 |
| Fast | 0.228 (2/4) | 0.259 (3/4) | 0.301 (3/4) | 0/4 | 0.207 (2/4) | 0.238 (2/4) |
| Circle | 0.055 | 0.122 | 0.182 | 0.088 | 0.098 | 0.086 |
| Square | 0.071 | 0.119 | 0.176 | 0.056 | 0.060 | 0.088 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 3.02 | 4.53 | 6.13 | 4.30 | 3.85 | 7.17 |
| Random figure 8 | 4.51 | 5.66 | 7.17 | 5.13 | 4.97 | 7.33 |
| Slow | 2.80 | 4.10 | 5.90 | 3.18 | 2.98 | 6.57 |
| Medium | 4.17 | 4.94 | 6.26 | 4.49 | 3.84 | 7.87 |
| Medium Plus | 6.54 | 7.56 | 8.64 | 6.79 | 6.59 | 8.67 |
| Fast | 12.1 (2/4) | 13.8 (3/4) | 14.8 (3/4) | 0/4 | 13.5 (2/4) | 14.4 (2/4) |
| Circle | 2.07 | 3.42 | 4.88 | 2.42 | 2.37 | 5.97 |
| Square | 2.05 | 3.48 | 5.34 | 2.64 | 2.41 | 5.99 |

Failed flights ended by: cables too close 2, drone too low 4, drones too close 6.

### Medium-to-Fast random walk, payload reference and cable force, 50 rounds

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.066 | 0.116 | 0.175 | 0.204 | 0.075 | 0.071 |
| Random figure 8 | 0.070 | 0.124 | 0.195 | 0.246 | 0.094 | 0.084 |
| Slow | 0.045 | 0.104 | 0.164 | 0.253 | 0.049 | 0.066 |
| Medium | 0.069 | 0.122 | 0.189 | 0.251 | 0.090 | 0.084 |
| Medium Plus | 0.085 | 0.131 | 0.189 | 0.211 | 0.096 | 0.092 |
| Fast | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 |
| Circle | 0.045 | 0.111 | 0.172 | 0.255 | 0.070 | 0.076 |
| Square | 0.044 | 0.101 | 0.175 | 0.150 | 0.037 | 0.054 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 3.05 | 4.73 | 6.52 | 9.21 | 3.71 | 5.47 |
| Random figure 8 | 3.50 | 5.44 | 7.39 | 8.70 | 4.81 | 5.51 |
| Slow | 2.96 | 4.30 | 6.20 | 9.74 | 3.34 | 5.05 |
| Medium | 4.20 | 5.34 | 6.85 | 10.4 | 4.89 | 6.26 |
| Medium Plus | 5.75 | 7.11 | 8.21 | 12.6 | 6.13 | 7.13 |
| Fast | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 | 0/4 |
| Circle | 2.58 | 4.00 | 5.41 | 8.53 | 3.87 | 4.73 |
| Square | 2.29 | 4.16 | 6.46 | 8.16 | 1.93 | 5.28 |

Failed flights ended by: cables too close 4, drone too low 3, drones too close 17.

### Students of 2026-11-04

The night's best DAgger student, the night's baseline and the pooled offline student, through the same conditions; the
rows of the 2026-11-03 batch above are repeated for comparison. Batch `.cache/robustness.sh pooled-offline
cable-direction-fast-heavy baseline-combo` (`experiments` ac638e9, no worktrees), log `logs/robustness/batch_2026-11-04.log`.
Mean position error over the seven references other than Fast (m), in brackets that mean over the model's own nominal,
failed flights out of 32 after a slash (all on Fast). Bold: the best per condition among all rows.

| Model | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Teacher | 0.022 | 0.101 (×4.6) | 0.169 (×7.8) | **0.024** (×1.1) / 4 | 0.133 (×6.1) | 0.197 (×9.1) |
| Open loop | **0.014** | 0.122 (×8.7) | 0.183 (×13.2) | 0.029 (×2.1) / 4 | **0.029** (×2.1) | 0.051 (×3.6) |
| No payload velocity, 25 rounds | 0.053 | 0.121 (×2.3) | 0.188 (×3.5) | 0.068 (×1.3) / 4 | 0.064 (×1.2) | 0.052 (×1.0) |
| Cable direction, 50 rounds | 0.074 / 2 | 0.124 (×1.7) / 1 | 0.176 (×2.4) / 1 | 0.086 (×1.2) / 4 | 0.090 (×1.2) / 2 | 0.090 (×1.2) / 2 |
| Offline, four cable-direction runs pooled | 0.032 | **0.097** (×3.0) | **0.151** (×4.7) | 0.049 (×1.5) / 4 | 0.072 (×2.3) | 0.083 (×2.6) |
| 100 rounds, cable direction, Fast-heavy, learning rate decay | 0.036 | 0.105 (×3.0) | 0.183 (×5.1) | 0.045 (×1.3) / 4 | 0.066 (×1.9) | 0.079 (×2.2) |
| 100 rounds, no payload velocity, combo with gate 0.1 | 0.038 | 0.108 (×2.8) | 0.172 (×4.5) | 0.052 (×1.4) / 4 | 0.062 (×1.6) | **0.046** (×1.2) |

Mean attitude error over the same references (°).

| Model | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Teacher | 1.13 | 3.76 | 5.48 | 1.52 | **1.44** | 24.61 |
| Open loop | **0.63** | 5.28 | 8.19 | **1.18** | 1.55 | 6.55 |
| No payload velocity, 25 rounds | 2.45 | 4.06 | 5.84 | 3.13 | 2.62 | **2.80** |
| Cable direction, 50 rounds | 3.59 | 4.81 | 6.33 | 4.14 | 3.86 | 7.08 |
| Offline, four cable-direction runs pooled | 1.73 | **3.50** | **5.44** | 3.45 | 2.69 | 6.74 |
| 100 rounds, cable direction, Fast-heavy, learning rate decay | 2.09 | 3.93 | 6.28 | 3.12 | 2.52 | 7.02 |
| 100 rounds, no payload velocity, combo with gate 0.1 | 1.82 | 3.86 | 5.71 | 2.20 | 1.91 | 2.82 |

Fast, position error (m) and completed flights.

| Model | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Teacher | 0.070 | 0.106 | 0.156 | 0/4 | 0.157 | 0.195 |
| Open loop | 0.057 | 0.119 | 0.177 | 0/4 | 0.062 | 0.077 |
| No payload velocity, 25 rounds | 0.279 | 0.279 | 0.310 | 0/4 | 0.239 | 0.292 |
| Cable direction, 50 rounds | 0.228 (2/4) | 0.259 (3/4) | 0.301 (3/4) | 0/4 | 0.207 (2/4) | 0.238 (2/4) |
| Offline, four cable-direction runs pooled | 0.108 | 0.133 | 0.172 | 0/4 | 0.114 | 0.132 |
| 100 rounds, cable direction, Fast-heavy, learning rate decay | 0.130 | 0.165 | 0.206 | 0/4 | 0.168 | 0.140 |
| 100 rounds, no payload velocity, combo with gate 0.1 | 0.153 | 0.173 | 0.212 | 0/4 | 0.158 | 0.161 |

Largest error per flight under the gusts, mean over the references other than Fast: position (m) / attitude (°).

| Model | Nominal | Gusts 5 m/s | Gusts 7.5 m/s |
|---|---|---|---|
| Teacher | 0.034 / 3.5 | 0.489 / 18.8 | 0.851 / 29.8 |
| Open loop | 0.059 / 3.6 | 0.463 / 21.5 | 0.694 / 33.4 |
| No payload velocity, 25 rounds | 0.106 / 5.5 | 0.532 / 15.3 | 0.840 / 24.2 |
| Cable direction, 50 rounds | 0.136 / 7.3 | 0.518 / 17.1 | 0.814 / 27.2 |
| Offline, four cable-direction runs pooled | 0.073 / 4.5 | 0.443 / 16.8 | 0.696 / 27.8 |
| 100 rounds, cable direction, Fast-heavy, learning rate decay | 0.074 / 5.0 | 0.486 / 17.8 | 0.824 / 29.5 |
| 100 rounds, no payload velocity, combo with gate 0.1 | 0.075 / 4.7 | 0.520 / 16.7 | 0.849 / 27.1 |

#### Offline, four cable-direction runs pooled

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.035 | 0.096 | 0.150 | 0.050 | 0.073 | 0.084 |
| Random figure 8 | 0.033 | 0.098 | 0.152 | 0.051 | 0.071 | 0.085 |
| Slow | 0.028 | 0.095 | 0.143 | 0.046 | 0.071 | 0.084 |
| Medium | 0.035 | 0.098 | 0.150 | 0.053 | 0.074 | 0.087 |
| Medium Plus | 0.040 | 0.096 | 0.151 | 0.053 | 0.070 | 0.088 |
| Fast | 0.108 | 0.133 | 0.172 | 0/4 | 0.114 | 0.132 |
| Circle | 0.028 | 0.095 | 0.143 | 0.043 | 0.069 | 0.072 |
| Square | 0.024 | 0.099 | 0.165 | 0.044 | 0.074 | 0.082 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 1.54 | 3.42 | 5.70 | 3.44 | 2.62 | 6.58 |
| Random figure 8 | 2.16 | 3.80 | 5.40 | 4.11 | 3.11 | 6.83 |
| Slow | 1.24 | 2.99 | 5.00 | 2.70 | 2.19 | 6.55 |
| Medium | 1.67 | 3.54 | 5.52 | 3.00 | 2.33 | 6.68 |
| Medium Plus | 3.54 | 4.93 | 6.38 | 5.07 | 3.93 | 7.87 |
| Fast | 8.73 | 9.00 | 9.92 | 0/4 | 8.60 | 11.5 |
| Circle | 0.93 | 2.60 | 4.33 | 2.57 | 2.35 | 6.42 |
| Square | 1.05 | 3.20 | 5.75 | 3.25 | 2.27 | 6.28 |


#### 100 rounds, cable direction, Fast-heavy, learning rate decay

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.036 | 0.099 | 0.174 | 0.050 | 0.071 | 0.079 |
| Random figure 8 | 0.039 | 0.106 | 0.181 | 0.050 | 0.065 | 0.085 |
| Slow | 0.031 | 0.102 | 0.177 | 0.040 | 0.063 | 0.084 |
| Medium | 0.037 | 0.114 | 0.203 | 0.048 | 0.067 | 0.082 |
| Medium Plus | 0.053 | 0.105 | 0.168 | 0.060 | 0.070 | 0.081 |
| Fast | 0.130 | 0.165 | 0.206 | 0/4 | 0.168 | 0.140 |
| Circle | 0.027 | 0.110 | 0.204 | 0.040 | 0.067 | 0.070 |
| Square | 0.026 | 0.102 | 0.174 | 0.027 | 0.058 | 0.072 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 1.80 | 3.88 | 6.34 | 3.16 | 2.48 | 6.96 |
| Random figure 8 | 2.81 | 4.22 | 6.30 | 3.65 | 3.14 | 7.17 |
| Slow | 1.76 | 3.56 | 6.12 | 2.80 | 2.17 | 6.43 |
| Medium | 2.13 | 4.36 | 7.10 | 3.11 | 2.43 | 6.86 |
| Medium Plus | 3.85 | 5.15 | 6.84 | 4.45 | 4.07 | 8.31 |
| Fast | 9.35 | 9.94 | 10.7 | 0/4 | 10.1 | 11.6 |
| Circle | 1.11 | 3.18 | 5.86 | 2.17 | 1.73 | 6.57 |
| Square | 1.15 | 3.15 | 5.42 | 2.51 | 1.59 | 6.85 |


#### 100 rounds, no payload velocity, combo with gate 0.1

Pos (m):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 0.042 | 0.105 | 0.165 | 0.056 | 0.067 | 0.046 |
| Random figure 8 | 0.048 | 0.108 | 0.170 | 0.062 | 0.070 | 0.055 |
| Slow | 0.026 | 0.101 | 0.162 | 0.034 | 0.045 | 0.038 |
| Medium | 0.043 | 0.110 | 0.179 | 0.056 | 0.061 | 0.051 |
| Medium Plus | 0.058 | 0.116 | 0.178 | 0.074 | 0.079 | 0.067 |
| Fast | 0.153 | 0.173 | 0.212 | 0/4 | 0.158 | 0.161 |
| Circle | 0.021 | 0.109 | 0.178 | 0.040 | 0.057 | 0.027 |
| Square | 0.027 | 0.106 | 0.174 | 0.039 | 0.058 | 0.037 |

Att (°):

| Reference | Nominal | Gusts 5 m/s | Gusts 7.5 m/s | Mass ×2 | COM +3 cm | Ropes + attach (thesis) |
|---|---|---|---|---|---|---|
| Random walk | 1.75 | 3.79 | 5.65 | 2.04 | 1.88 | 2.73 |
| Random figure 8 | 2.40 | 4.08 | 5.64 | 2.83 | 2.52 | 3.05 |
| Slow | 1.26 | 3.52 | 5.36 | 1.68 | 1.38 | 2.54 |
| Medium | 1.60 | 3.83 | 5.93 | 2.11 | 1.83 | 2.69 |
| Medium Plus | 4.20 | 5.16 | 6.36 | 4.45 | 4.17 | 4.53 |
| Fast | 9.41 | 9.52 | 10.1 | 0/4 | 8.87 | 9.91 |
| Circle | 0.74 | 3.04 | 5.00 | 1.17 | 0.83 | 2.07 |
| Square | 0.82 | 3.59 | 6.00 | 1.12 | 0.80 | 2.13 |

## Learning the feedforward (offline)

No Isaac and no teacher: the student's MLP (3 × 256) learns each drone's reference from the payload reference, on
Medium-to-Fast walks turned into the rig's reference with the teacher's model, as the training task does. Script
`.cache/offline/feedforward_learnability.py`, 20,000 steps of 1024 rows, cosine learning rate from 1e-3, 30
held-out walks (10 per level). Node-1 position error in cm, the whole horizon in the last column.

### Feedforward from the payload reference

- In: the payload reference at the 21 nodes (position from its own position now, velocity, acceleration, orientation,
  body rate, body angular acceleration) and the attach point. Out: the drone's reference at the nodes (position from
  the same point, velocity, acceleration).
- Varied: the number of 40 s walks (25 is about one DAgger run) and standardised inputs.
- Linear fit on the same inputs: 67–68 cm at every number of walks.

| Walks | Inputs | Medium | Medium Plus | Fast | All | All, horizon |
|---|---|---|---|---|---|---|
| 25 | raw | 2.06 | 3.83 | 7.13 | 4.34 | 6.37 |
| 250 | raw | 1.14 | 2.23 | 4.08 | 2.48 | 3.23 |
| 1000 | raw | 1.04 | 2.07 | 3.58 | 2.23 | 2.89 |
| 25 | standardised | 2.23 | 4.22 | 8.05 | 4.83 | 6.30 |
| 250 | standardised | 1.12 | 2.21 | 4.08 | 2.47 | 2.64 |
| 1000 | standardised | **1.03** | **1.98** | **3.53** | **2.18** | **2.27** |

## Before 2026-10-19 (old teacher)

Reference sampled every 0.1 s, test references A2 (= Medium) and A4 (≈ Medium Plus) CSVs, validate 1 flight per
reference. Not comparable with the tables above. All students trained on random figure 8s. Bold: the better of the
two teachers; among the students, the best per reference (nominal validation).

### Teacher

- The MPC teacher as of 2026-10-11.
- No log kept; numbers from notes.

| Reference | Pos (m) | Att (°) | Completed |
|---|---|---|---|
| Random figure 8 | **0.055** | **0.94** | 1/1 |
| A2 | 0.080 | **1.22** | 1/1 |
| A4 | 0.093 | **2.58** | 1/1 |
| Circle | 0.034 | **0.55** | 1/1 |
| Square | 0.037 | **0.59** | 1/1 |

### Teacher with rotor drag

- As above, with rotor drag in the simulation (branch `experiment/realism`).
- Log: `logs/validate/teacher_rotor-drag.log`.

| Reference | Pos (m) | Att (°) | Completed |
|---|---|---|---|
| Random figure 8 | 0.081 | 4.12 | 1/1 |
| A2 | **0.038** | 2.83 | 1/1 |
| A4 | **0.077** | 3.65 | 1/1 |
| Circle | **0.031** | 0.63 | 1/1 |
| Square | **0.028** | 1.05 | 1/1 |

### State MLP, pure DAgger, 12 rounds

- Pure DAgger, 12 rounds.
- Run: `state-mlp/fig8-random_pure-dagger_12-rounds`. No log kept; numbers from notes.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | **0.080** | 1.5× | **2.7** | 2.9× | 1/1 |
| A2 | 0.136 | 1.7× | 3.6 | 3.0× | 1/1 |
| A4 | 0.169 | 1.8× | 5.6 | 2.2× | 1/1 |
| Circle | 0.065 | 1.9× | 1.7 | 3.1× | 1/1 |
| Square | 0.064 | 1.7× | 1.8 | 3.1× | 1/1 |

### State MLP, thesis schedule

- Thesis schedule: linear β, payload pushes in the last rounds (they never acted), first 2 s of each episode skipped; 25 rounds. Branch `experiment/thesis-pinn`.
- Run: `state-mlp/fig8-random_thesis-schedule`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.083 | 1.5× | 3.72 | 4.0× | 1/1 |
| A2 | **0.071** | 0.9× | 2.08 | 1.7× | 1/1 |
| A4 | **0.084** | 0.9× | **3.47** | 1.3× | 1/1 |
| Circle | 0.062 | 1.8× | 1.52 | 2.8× | 1/1 |
| Square | 0.060 | 1.6× | 1.52 | 2.6× | 1/1 |

### State MLP, pure DAgger, first 2 s skipped

- Pure DAgger, first 2 s of each episode skipped, 25 rounds. Branch `experiment/thesis-pinn`.
- Run: `state-mlp/fig8-random_pure-dagger_skip-first-2s`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.100 | 1.8× | 4.22 | 4.5× | 1/1 |
| A2 | 0.075 | 0.9× | 2.38 | 2.0× | 1/1 |
| A4 | 0.100 | 1.1× | 4.04 | 1.6× | 1/1 |
| Circle | 0.039 | 1.1× | 1.64 | 3.0× | 1/1 |
| Square | 0.040 | 1.1× | 1.66 | 2.8× | 1/1 |

### State MLP, pure DAgger, first 2 s skipped, round 11

- The same run, validated at round 11.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.136 | 2.5× | 6.40 | 6.8× | 1/1 |
| A2 | 0.204 | 2.5× | 4.07 | 3.3× | 1/1 |
| A4 | 0.191 | 2.1× | 7.23 | 2.8× | 1/1 |
| Circle | 0.102 | 3.0× | 3.68 | 6.7× | 1/1 |
| Square | 0.105 | 2.8× | 3.71 | 6.3× | 1/1 |

### State MLP, no payload velocity

- As pure DAgger with the first 2 s skipped, without the payload velocity input.
- Run: `state-mlp/fig8-random_pure-dagger_skip-first-2s_no-payload-velocity`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.107 | 1.9× | 3.83 | 4.1× | 1/1 |
| A2 | 0.076 | 0.9× | 2.56 | 2.1× | 1/1 |
| A4 | 0.091 | 1.0× | 3.68 | 1.4× | 1/1 |
| Circle | **0.023** | 0.7× | 1.19 | 2.2× | 1/1 |
| Square | **0.026** | 0.7× | **1.21** | 2.1× | 1/1 |

### State MLP, pure DAgger, payload pushes

- Pure DAgger, 25 rounds, payload pushes in rounds 12–24 (acting). Branch `experiment/realism`.
- Run: `state-mlp/fig8-random_pure-dagger_25-rounds_push`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.126 | 2.3× | 3.29 | 3.5× | 1/1 |
| A2 | 0.125 | 1.6× | **2.05** | 1.7× | 1/1 |
| A4 | 0.096 | 1.0× | 3.64 | 1.4× | 1/1 |
| Circle | 0.041 | 1.2× | 1.36 | 2.5× | 1/1 |
| Square | 0.046 | 1.2× | 1.39 | 2.4× | 1/1 |

Validated with input noise, rotor drag, or both:

| Reference | Noise pos | Noise att | Drag pos | Drag att | Both pos | Both att |
|---|---|---|---|---|---|---|
| Random figure 8 | 0.126 | 3.27 | 0.143 | 3.46 | 0.143 | 3.45 |
| A2 | 0.125 | 2.06 | 0.089 | 2.29 | 0.089 | 2.29 |
| A4 | 0.096 | 3.65 | 0.114 | 3.37 | 0.113 | 3.36 |
| Circle | 0.041 | 1.37 | 0.029 | 1.45 | 0.029 | 1.46 |
| Square | 0.046 | 1.42 | 0.036 | 1.66 | 0.037 | 1.69 |

### State MLP, payload pushes, trained with input noise and rotor drag

- As above, trained with noisy inputs and rotor drag.
- Run: `state-mlp/fig8-random_pure-dagger_25-rounds_push_noise_rotor-drag`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.124 | 2.3× | 5.22 | 5.6× | 1/1 |
| A2 | 0.151 | 1.9× | 3.51 | 2.9× | 1/1 |
| A4 | 0.124 | 1.3× | 5.01 | 1.9× | 1/1 |
| Circle | 0.046 | 1.4× | **1.08** | 2.0× | 1/1 |
| Square | 0.052 | 1.4× | 1.40 | 2.4× | 1/1 |

Validated with input noise, rotor drag, or both:

| Reference | Noise pos | Noise att | Drag pos | Drag att | Both pos | Both att |
|---|---|---|---|---|---|---|
| Random figure 8 | 0.124 | 5.23 | 0.110 | 5.18 | 0.109 | 5.19 |
| A2 | 0.151 | 3.50 | 0.079 | 3.62 | 0.079 | 3.61 |
| A4 | 0.123 | 5.02 | 0.121 | 5.03 | 0.121 | 5.03 |
| Circle | 0.046 | 1.06 | 0.031 | 1.04 | 0.031 | 1.02 |
| Square | 0.052 | 1.37 | 0.033 | 1.43 | 0.033 | 1.41 |

### TCN + PINN, absolute reference attitude

- The thesis student: TCN encoders over 2 s of history, PINN decoder; reference attitude absolute, as in the thesis; thesis schedule. Branch `experiment/thesis-pinn`.
- Run: `history-tcn-pinn/abs-ref-attitude_thesis-schedule`. No log kept; numbers from notes, completion not recorded.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.132 | 2.4× | 15 | 16× | – |
| A2 | 0.172 | 2.1× | 20 | 16× | – |
| A4 | 0.150 | 1.6× | 12 | 4.7× | – |
| Circle | 0.081 | 2.4× | 58 | 105× | – |
| Square | 0.067 | 1.8× | 39 | 66× | – |

### TCN + PINN, relative reference attitude

- As above, reference attitude relative to the payload.
- Run: `history-tcn-pinn/rel-ref-attitude_thesis-schedule`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.110 | 2.0× | 4.40 | 4.7× | 1/1 |
| A2 | 0.443 | 5.5× | 7.25 | 5.9× | 1/1 |
| A4 | 0.239 | 2.6× | 5.91 | 2.3× | 1/1 |
| Circle | 0.078 | 2.3× | 2.57 | 4.7× | 1/1 |
| Square | 0.074 | 2.0× | 2.60 | 4.4× | 1/1 |

### TCN + PINN, relative attitude, payload velocity

- As above, plus the payload velocity input.
- Run: `history-tcn-pinn/rel-ref-attitude_payload-velocity_thesis-schedule`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.113 | 2.1× | 4.11 | 4.4× | 1/1 |
| A2 | 0.205 | 2.6× | 8.25 | 6.8× | 1/1 |
| A4 | 0.154 | 1.7× | 5.32 | 2.1× | 1/1 |
| Circle | 0.083 | 2.4× | 2.76 | 5.0× | 1/1 |
| Square | 0.075 | 2.0× | 2.32 | 3.9× | 1/1 |

### TCN + PINN, relative attitude, payload velocity, pure DAgger

- As above, pure DAgger with the first 2 s skipped instead of the thesis schedule.
- Run: `history-tcn-pinn/rel-ref-attitude_payload-velocity_pure-dagger_skip-first-2s`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.136 | 2.5× | 4.45 | 4.7× | 1/1 |
| A2 | 0.213 | 2.7× | 6.79 | 5.6× | 1/1 |
| A4 | 0.171 | 1.8× | 5.88 | 2.3× | 1/1 |
| Circle | 0.072 | 2.1× | 3.62 | 6.6× | 1/1 |
| Square | 0.075 | 2.0× | 3.26 | 5.5× | 1/1 |

### TCN + MLP decoder, absolute reference attitude

- TCN encoders over 2 s of history, MLP decoder; reference attitude absolute; thesis schedule. Branch `experiment/thesis-pinn`.
- Run: `history-tcn-mlp/abs-ref-attitude_thesis-schedule`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.208 | 3.8× | 66.1 | 70× | 1/1 |
| A2 | 0.322 | 4.0× | 79.3 | 65× | 1/1 |
| A4 | 0.248 | 2.7× | 59.0 | 23× | 1/1 |
| Circle | 0.234 | 6.9× | 126 | 229× | 1/1 |
| Square | 0.216 | 5.8× | 106 | 180× | 1/1 |

### TCN + MLP decoder, relative reference attitude

- As above, reference attitude relative to the payload.
- Run: `history-tcn-mlp/rel-ref-attitude_thesis-schedule`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.187 | 3.4× | 7.03 | 7.5× | 1/1 |
| A2 | 0.399 | 5.0× | 45.5 | 37× | 1/1 |
| A4 | 0.304 | 3.3× | 36.7 | 14× | 1/1 |
| Circle | 0.158 | 4.6× | 6.40 | 12× | 1/1 |
| Square | 0.161 | 4.4× | 5.79 | 9.8× | 1/1 |

### TCN + MLP decoder, relative attitude, payload velocity

- As above, plus the payload velocity input.
- Run: `history-tcn-mlp/rel-ref-attitude_payload-velocity_thesis-schedule`.

| Reference | Pos (m) | Pos / teacher | Att (°) | Att / teacher | Completed |
|---|---|---|---|---|---|
| Random figure 8 | 0.148 | 2.7× | 6.52 | 6.9× | 1/1 |
| A2 | 0.225 | 2.8× | 13.6 | 11× | 1/1 |
| A4 | 0.304 | 3.3× | 13.8 | 5.3× | 1/1 |
| Circle | 0.112 | 3.3× | 5.68 | 10× | 1/1 |
| Square | 0.090 | 2.4× | 5.60 | 9.5× | 1/1 |
