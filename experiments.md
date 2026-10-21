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
| Random walk | **0.048** | 2.0× | 1.97 | 1.9× | 4/4 |
| Random figure 8 | **0.048** | 2.1× | 2.90 | 1.8× | 4/4 |
| Slow | **0.029** | 1.5× | 1.40 | 2.2× | 4/4 |
| Medium | **0.045** | 2.3× | 2.02 | 3.0× | 4/4 |
| Medium Plus | **0.060** | 2.3× | 4.40 | 1.5× | 4/4 |
| Fast | 0.122 | 1.8× | 9.50 | 1.9× | 4/4 |
| Circle | **0.025** | 1.2× | 1.05 | 2.4× | 4/4 |
| Square | 0.032 | 1.6× | 1.23 | 2.1× | 4/4 |

## Plant mismatch

All trained on the nominal plant, validated with the plant or the model changed, 4 flights per reference, seed 0.
`validate.py` flags: `--payload_mass_scale`, `--payload_com_offset` (sim payload, Isaac Lab startup events),
`--model_cable_length`, `--model_attach_offset` (the model the teacher and model-based inputs use; sim unchanged).
Batch: `.cache/plant_mismatch.sh` and `.cache/plant_mismatch_rest.sh`, logs in `logs/plant_mismatch/`. A failed
flight count shows as (completed/4).

### Summary

Mean position error over the 8 references (m), and in brackets that mean over the controller's own nominal.
Bold: the more robust student per condition (fewest failed flights, then the smallest ratio). Failed flights out of
32 after a slash; a reference with no completed flight is left out of the mean.

| Condition | Teacher | Baseline (full state) | Feedforward (no payload state) |
|---|---|---|---|
| Nominal | 0.028 | 0.073 | 0.051 |
| Mass ×0.7 | 0.032 (×1.2) | 0.079 (×1.1) | **0.053 (×1.0)** |
| Mass ×1.3 | 0.027 (×1.0) | **0.075 (×1.0)** | 0.060 (×1.2) |
| Mass ×1.6 | 0.036 (×1.3) | **0.077 (×1.1) / 1 failed** | 0.071 (×1.4) / 1 failed |
| COM +3 cm | 0.136 (×4.9) | **0.085 (×1.2)** | 0.076 (×1.5) |
| Model cable 0.9 m | 0.207 (×7.5) / 2 failed | **0.073 (×1.0)** | 0.072 (×1.4) |
| Model cable 1.1 m | 0.197 (×7.1) | **0.073 (×1.0)** | 0.064 (×1.3) |
| Model attach +3 cm | 0.289 (×10.4) | **0.076 (×1.0)** | 0.099 (×2.0) |

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
