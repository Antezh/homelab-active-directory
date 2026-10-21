# Phase 01 — Network & Host Planning

**Started:** 2026-07-20
**Raw working notes:** none for this phase. Planning was done in conversation with an AI assistant (Claude) while exploring project ideas, so the decisions below are written up from memory.

---

## Purpose

Decide what the lab runs on, how big the first VM should be, and how it connects to the network, before building anything. The goal was a setup that is safe to break, easy to rebuild and good for learning Active Directory and IT infrastructure hands on.

---

## Build

Decisions made during planning:

| Area | Decision |
|---|---|
| Hypervisor | VMware Workstation Pro |
| VM host | Ryzen 7 9800X3D, 32GB DDR5, 3TB NVMe |
| First VM | `DC01`, Windows Server 2025 Standard, Desktop Experience (evaluation edition) |
| VM resources | 2 vCPUs, 4GB RAM, 60GB virtual disk |
| Network | Isolated host only network, `VMnet2`, `192.168.50.0/24` |
| DC01 address | `192.168.50.10`, static |

---

## Configuration

Layout of the lab at this stage:

```
Host PC (VMware Workstation Pro)
└── VMnet2 (host only, isolated)  192.168.50.0/24
    └── DC01  192.168.50.10
```

The decisions and the reasoning behind them:

**Host only network.** The lab does not need internet access, so the VMs are kept on a network that is isolated from my home LAN and from the internet. This is safer, since nothing in the lab can be reached from outside or reach out by mistake. It is also simpler to work with while I learn.

**Address range.** I picked `192.168.50.0/24` and `.10` for the domain controller mostly because they are easy to find and remember. There was no deeper technical reason. The DC gets a static address because everything else in the domain will depend on finding it.

**Windows Server 2025 Standard, Desktop Experience.** I chose the version with the graphical interface so I can learn what the tools look like and still use PowerShell inside the OS. Server Core would make more sense if I already had Windows Server experience. But since I do not, I chose the easier way to learn first. 

**VM size.** 2 vCPUs, 4GB RAM and 60GB of disk is enough for a single domain controller in a small lab, and leaves plenty of headroom on the host for more VMs later. The specific resource allocation was determined after consulting with Claude AI, which recommended these specs as a solid baseline for my setup.

---

## Challenges & Troubleshooting

No problems came up during the planning itself.

One planning decision did cause a problem later. Because the lab network is isolated, the server could not reach the internet to activate its evaluation license, and Windows shut it down on a timer. That is covered in the Phase 03 notes.

---

## Lessons Learned

- Isolating the lab network is a good default, but it has side effects. Anything that needs the internet (activation, updates) has to be planned for.
- Choosing the Desktop Experience edition was the right call for learning. I can move to Server Core later when I know what I am looking at.

---

## Result

A clear plan for the first build: one domain controller VM on an isolated network with a fixed address. This is what Phase 02 is built on.

**Next phase:** [Domain Controller Setup →](./02-domain-controller-setup.md)
