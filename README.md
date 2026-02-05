# MetaSandwich-IL-Jacket — Insertion Loss (IL) for multilayer pipeline jackets (MATLAB)

MetaSandwich-IL-Jacket is a MATLAB codebase for computing the **insertion loss (IL)** of a multilayer pipeline jacket concept (pipe + porous/damping layer + outer jacket), using a transfer-matrix / impedance-based approach.

- Legacy name: **SooMa** (kept only for historical reference)
- Target users: acoustics engineers / researchers working on pipe noise control

中文简介：
- 这是一个用于计算**多层管道包覆结构插入损失（Insertion Loss, IL）**的 MATLAB 工具。
- 项目从旧的 SooMa 代码整理并更名而来。

## Quick start / 快速开始

```matlab
% From repo root:
MetaSandwich_IL_Jacket_Main();

% or run the legacy script directly:
main;
```

## What the code does / 功能说明

- Computes IL by comparing the treated (with jacket) vs. bare pipe case
- Provides frequency-domain curves and helper post-processing (e.g., octave/third-octave utilities, if used)
- Includes measured data in `data/` for comparison (if present)

## Project structure / 目录结构

- `main.m` — main analysis script (legacy entrypoint)
- `MetaSandwich_IL_Jacket_Main.m` — convenience entrypoint (recommended)
- `src/` — helper functions + parameter scripts
- `data/` — measurement data (if present)
- `tests/` — minimal smoke test (CI)

## Notes on correctness / 重要说明

- **Do not treat the numeric values in README as authoritative defaults.**
  The source of truth is the parameter blocks/files used by `main.m`.
- If you change materials/geometry/frequency range, update the parameter files or the blocks in `main.m`.

## Citation

See `CITATION.cff`.

## License

BSD-3-Clause (see `LICENSE`).
