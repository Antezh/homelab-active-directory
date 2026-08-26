# Active Directory Homelab

A self-built Windows Server 2025 Active Directory environment, deployed and documented as a portfolio project while transitioning into IT support / systems administration.

> 🚧 **Status:** In progress - new phases are added as the lab grows. See [`docs/`](./docs) for detailed write-ups of each stage.

> Raw working notes (dated, unedited, in Swedish) are kept in [`raw-notes/`](./raw-notes) for transparency.

---

## Purpose & Goal

I'm a former train driver moving into IT, with a BSc in Computer and Systems Sciences. This lab exists to build hands on experience with the technologies a junior sysadmin or IT support role may touch on a day to day basis, and to document that process transparently, including what went wrong along the way.

**Goals for this environment:**
- Stand up a functioning single-domain AD forest from scratch
- Design and implement a logical OU / group structure
- Apply Group Policy to enforce basic security and configuration baselines
- Practice real troubleshooting and recovery, not just "happy path" clicking
- Build a repeatable documentation habit similar to real change-management practice

---

## Environment / Tech Stack

| Component | Details |
|---|---|
| Hypervisor | VMware Workstation Pro |
| VM Host | Ryzen 7 9800X3D, 32GB DDR5, 3TB NVMe |
| Domain Controller | Windows Server 2025 — `DC01.homelab.local` |
| Network | Isolated `VMnet2`, `192.168.50.0/24` |
| Domain | `homelab.local` |

*(Additional VMs such as potential member servers, client machines, etc. are added as the lab expands. See docs for current state.)*

---

## The Build (phase index)

Each phase below is documented separately in [`docs/`](./docs), following: **Purpose → Build → Config → Challenges/Troubleshooting → Lessons Learned → Result**.

| # | Phase | Summary |
|---|---|---|
| 01 | [Network & Host Planning](./docs/01-planning.md) | Hardware assessment, isolated lab network design |
| 02 | [Domain Controller Setup](./docs/02-domain-controller-setup.md) | VMnet2 config, Windows Server 2025 install, DC01 promotion, DSRM recovery after a rename issue |
| 03 | [OU & Group Design](./docs/03-ou-design.md) | Flat department-based OU model (Sales, IT, HR, Finance) |

*(Rows are added as new phases are completed)*

---

## Configuration Highlights

- Domain: `homelab.local`
- Domain Controller: `DC01` (all FSMO roles)
- Network: isolated `VMnet2` — `192.168.50.0/24`
- OU structure: flat, department-based (Sales / IT / HR / Finance)

As already pointed out: Full configuration detail lives in each phase's doc, not here. This section is simply a quick reference, not the full log.

---

## Challenges & Troubleshooting (project-wide highlights)

The most valuable parts of this lab weren't the steps that worked first try, they were the ones that didn't. A few notable ones (full detail in the relevant phase doc):

- **DC promotion trust error** - promoted the server *before* renaming it to `DC01`, which broke the trust relationship. Fixed by using DSRM (Directory Services Restore Mode) to cleanly demote and re-promote *after* renaming the host first. Lesson learned: rename before promotion, always.

*(More entries added as new issues arise, as they most likely will arise)*

---

## Lessons Learned / Takeaways

- Hostname and domain identity should be finalized **before** promoting a server to DC.
- DSRM is a proven recovery path when normal domain login is broken.

*(This section grows across the whole project. Think of it as the accumulated list of "what I wish I'd known before".)*

---

## Result (current state)

A healthy single-domain AD forest with `DC01.homelab.local` holding all FSMO roles, verified via `Get-ADDomain`, running on an isolated lab network with an initial OU structure in place. Next phase: Group Policy baseline.

---

## Repo Structure

```
homelab-active-directory/
├── README.md               ← you are here
├── docs/
│   ├── 01-planning.md
│   ├── 02-domain-controller-setup.md
│   └── 03-ou-design.md
├── raw-notes/
│   └── AD_DS_Documentation.docx   ← dated, unedited working log (Swedish)
├── screenshots/
│   └── ...                 ← numbered, referenced from docs/
└── scripts/
    └── ...                 ← PowerShell used during setup (e.g. Get-ADDomain checks)
```

---

*Documentation in this repo was structured and edited with the help of AI (Claude) as a learning aid and time saver. All lab work, configuration and troubleshooting was performed hands-on in the VM environment.*

---

## Skills Demonstrated

`Active Directory Domain Services` `DNS` `Group Policy (GPO)` `Windows Server 2025` `VMware Workstation Pro` `Network Segmentation` `Disaster Recovery (DSRM)` `Technical Documentation` `Git / GitHub`
