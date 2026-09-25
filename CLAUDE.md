# Project: Native iOS 3D Anatomy App (SwiftUI)

## Goal
Build a fully featured, medically accurate 3D human anatomy app for iOS in SwiftUI, for medical-student study use.

## About me
- Medical student. I work from my phone only; I have no PC, so I never run Blender, Xcode or any desktop tool myself.
- My build, signing and distribution setup is already solved: Apple Developer account, cloud macOS builds, TestFlight, and a GitHub repo. Ask me for repo and pipeline details only if you can't find them.
- My role is anatomical reviewer. I spot-check models against Netter's and Gray's and report issues. You handle all technical work.

## How to work with me
- Don't pause mid-task for permission or clarification. Choose the reasonable option, state what you chose, and continue.
- Keep token use per message low. Automate repeated procedures with scripts instead of redoing them by hand.
- Never block or idle-wait on long jobs such as builds, downloads or mesh processing. Start them, keep working, and collect the results later.
- You can't see the app running. Rely on build logs and my feedback, and tell me exactly what to check on screen after each build.
- Explain problems in plain terms. I know the anatomy, and I know these 3D basics, but not Blender:
  - meshes, triangle count and decimation
  - LOD (level of detail)
  - normals
  - coordinate systems and scale
  - materials
  - USDZ
  - segmentation and smoothing

## Core accuracy principle
Accuracy comes from real anatomical data, never from hand-modelled guesses. Use three tiers of models:
1. Existing open, scan-derived models where their quality is good.
2. Meshes built from segmented CT/MRI data to fill gaps: segment the scan, convert to a mesh with marching cubes, clean, smooth, then simplify.
3. Hand-built or procedural geometry only for schematic teaching views, clearly labelled "schematic" in the app.

Known limits to respect:
- Scan resolution can't capture structures thinner than a few slices, such as small nerves and vessels. Give these dedicated detail views or schematic treatment, and label them honestly.
- Over-smoothing shrinks and rounds structures. Keep smoothing conservative and log it per structure.

## Accuracy of information and models (owner's standing rule)
- Every fact shown in the app (names, hierarchy, relations, attachments, innervation, blood supply, function, variants) comes from reliable, comprehensive sources and is cross-checked across multiple independent sources until certain. Protocol: docs/phase1/content-accuracy.md.
- Build models from both full-body references (global position, proportion, scale, relations) and body-part references (local detail), and validate each against the other. Plan: docs/phase1/model-references.md.

## Scope and order
Start with ONE region or system, taken end to end through the whole pipeline and into the app, before scaling up. Pick the region that best proves the pipeline, state the choice, and continue. Expand region by region after that.

## Phase 1: Source audit (do this first)
Search the web and evaluate these candidates for coverage, quality, file formats and license terms:
- BodyParts3D
- Z-Anatomy
- TotalSegmentator dataset
- Open Anatomy / SPL atlases
- Visible Human Project
- Terminologia Anatomica / FMA (for naming and hierarchy)

Deliverables:
- A coverage matrix by body system, showing which source covers what and how well.
- A list of known gaps. Expect peripheral nerves, small vessels and fine structures to be weak.
- A licensing summary with attribution requirements, and a flag on anything that blocks App Store distribution.

Licensing is settled here, before any models are built.

Proprietary sets such as Complete Anatomy and Visible Body are off-limits.

## Phase 2: Asset pipeline (scripted, headless, repeatable)
- Run Blender headless, driven by Python scripts, plus Python mesh tools as needed. Everything is reproducible from scripts in the repo.
- Download the chosen sources.
- Normalize them to one shared coordinate system and scale.
- Map every structure to a Terminologia Anatomica or FMA ID and name.
- Fix normals, clean the meshes, then decimate each to multiple levels of detail suitable for iPhone.
- Export to USDZ.
- Generate a JSON manifest per structure containing:
  - ID, name and synonyms
  - system, region and parent
  - source and license
  - processing notes (smoothing and decimation level)
- Include a render-check step that outputs preview images of each processed mesh, from standard anatomical views, for my review.

## Phase 3: App architecture
- Use the latest stable SwiftUI with RealityKit, falling back to SceneKit only if needed.
- Use a modular project structure with on-demand asset loading, so the full body isn't loaded into memory at once.
- Keep the app bundle small. Download region packs on demand instead of bundling the full body, and cache them for offline use.
- Store 3D assets in Git LFS. Tell me if LFS storage or bandwidth is approaching GitHub's quota.

## Phase 4: Features (in priority order)
1. 3D viewer with rotate, zoom and pan.
2. Layer peeling: skin, then muscle, then organs, then bone.
3. Toggles to show or hide each body system.
4. Tap a structure to identify it, with a detail card.
5. Search with synonyms, plus isolate and hide controls for individual structures.
6. Region-focused views, including dedicated detail views for fine structures.
7. Quiz modes: identify the structure, and locate the structure.
8. Personal notes and bookmarks.
9. A sources and attribution screen.

Later additions: cross-sections, and clinical correlations clearly marked as illustrative.

## Phase 5: Verification and iteration
- Build a checklist for spot-checking labels and structures against Netter's and Gray's.
- Work in review rounds: build, send me previews and a check list, I report, you fix, then build again.
- Triage my reports by type:
  - anatomy error: wrong shape, position or relation
  - alignment bug: floating, rotated or mis-scaled
  - mesh issue: bad normals, holes or over-decimation
  - cosmetic: materials and colours
- Log every known inaccuracy or simplification visibly in the app.

## Start now
Begin with Phase 1. Deliver the coverage matrix and licensing summary, pick the first region, then propose a concrete Phase 2 plan and move straight into it.
