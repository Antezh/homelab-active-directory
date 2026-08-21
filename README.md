# Active Directory Homelab

A self-built Windows Server 2025 Active Directory environment, deployed and documented as a portfolio project while transitioning into IT support / systems administration.

> 🚧 **Status:** In progress — new phases are added as the lab grows. See [`docs/`](./docs) for detailed write-ups of each stage.

---

## 🎯 Purpose & Goal

I'm a former train driver moving into IT, with a BSc in Computer and Systems Sciences and the Google IT Support Professional Certificate. This lab exists to build hands-on, demonstrable experience with the technologies a junior sysadmin / IT support role actually touches day to day — Active Directory, DNS, Group Policy, and general Windows Server administration — and to document that process transparently, including what went wrong along the way.

**Goals for this environment:**
- Stand up a functioning single-domain AD forest from scratch
- Design and implement a logical OU / group structure
- Apply Group Policy to enforce basic security and configuration baselines
- Practice real troubleshooting and recovery, not just "happy path" clicking
- Build a repeatable documentation habit similar to real change-management practice

---

## 🖥️ Environment / Tech Stack

| Component | Details |
|---|---|
| Hypervisor | VMware Workstation Pro |
| VM Host | Ryzen 7 9800X3D, 32GB DDR5, 3TB NVMe |
| Domain Controller | Windows Server 2025 — `DC01.homelab.local` |
| Network | Isolated `VMnet2`, `192.168.50.0/24` |
| Domain | `homelab.local` |

*(Additional VMs — member servers, client machines — are added as the lab expands; see docs for current state.)*

---

## 🏗️ The Build (phase index)

Each phase below is documented in full in [`docs/`](./docs), following: **Purpose → Build → Config → Challenges/Troubleshooting → Lessons Learned → Result**.

| # | Phase | Summary |
|---|---|---|
| 01 | [Network & Host Planning](./docs/01-planning.md) | Hardware assessment, isolated lab network design |
| 02 | [Domain Controller Setup](./docs/02-domain-controller-setup.md) | VMnet2 config, Windows Server 2025 install, DC01 promotion, DSRM recovery after a rename issue |
| 03 | [OU & Group Design](./docs/03-ou-design.md) | Flat department-based OU model (Sales, IT, HR, Finance) |

*(Rows are added as new phases are completed — GPO, DNS hardening, backups, etc.)*

---

## 🔧 Configuration Highlights

- Domain: `homelab.local`
- Domain Controller: `DC01` (all FSMO roles)
- Network: isolated `VMnet2` — `192.168.50.0/24`
- OU structure: flat, department-based (Sales / IT / HR / Finance)

Full configuration detail lives in each phase's doc, not here — this section is a quick reference, not the full log.

---

## 🧩 Challenges & Troubleshooting (project-wide highlights)

The most valuable parts of this lab weren't the steps that worked first try — they were the ones that didn't. A few notable ones (full detail in the relevant phase doc):

- **DC promotion trust error** — promoted the server *before* renaming it to `DC01`, which broke the trust relationship. Fixed by using DSRM (Directory Services Restore Mode) to cleanly demote and re-promote *after* renaming the host first. Lesson: rename before promotion, always.

*(More entries added as new issues come up — that's the point of the log.)*

---

## 📚 Lessons Learned / Takeaways

- Hostname and domain identity should be finalized **before** promoting a server to DC — not after.
- DSRM is a legitimate and useful recovery path, not just a "break glass" panic button.
- A flat OU structure is easier to reason about at small scale, but the design should anticipate growth (nested OUs, delegated admin) rather than needing a rebuild later.

*(This section grows across the whole project — think of it as the running "what I'd tell past-me" list.)*

---

## ✅ Result (current state)

A healthy single-domain AD forest with `DC01.homelab.local` holding all FSMO roles, verified via `Get-ADDomain`, running on an isolated lab network with an initial OU structure in place. Next phase: Group Policy baseline.

---

## 🗂️ Repo Structure

```
homelab-active-directory/
├── README.md              ← you are here
├── docs/
│   ├── 01-planning.md
│   ├── 02-domain-controller-setup.md
│   └── 03-ou-design.md
├── screenshots/
│   └── ...                ← numbered, referenced from docs/
└── scripts/
    └── ...                ← PowerShell used during setup (e.g. Get-ADDomain checks)
```

---

## 🛠️ Skills Demonstrated

`Active Directory Domain Services` `DNS` `Group Policy (GPO)` `Windows Server 2025` `VMware Workstation Pro` `Network Segmentation` `Disaster Recovery (DSRM)` `Technical Documentation` `Git / GitHub`
