# Phase 02 — Domain Controller Setup

**Dates:** 2026-07-21 – 2026-07-22
**Raw working notes:** [`raw-notes/AD_DS_Documentation.docx`](../raw-notes/AD_DS_Documentation.docx)

---

## Purpose

Promote a Windows Server 2025 VM to the first Domain Controller of a new Active Directory forest called `homelab.local`, establishing the foundation the rest of the lab is built on.

---

## Build

- VMware Workstation Pro used as the hypervisor for the lab
- Windows Server 2025 installed on the VM intended to become the Domain Controller
- Target hostname: `DC01`
- Target domain: `homelab.local`
- Network: isolated `VMnet2`, `192.168.50.0/24`

---

## Configuration

**Static IP** (a DC needs a fixed and predictable address):

| Setting | Value |
|---|---|
| IP address | `192.168.50.10` |
| Subnet mask | `255.255.255.0` |
| Default gateway | *left blank — isolated lab network* |
| Preferred DNS server | `127.0.0.1` *points to itself, since this VM is also the DNS server* |

Configured via: `Control Panel → Network and Sharing Center → Change adapter settings → [adapter] → Properties → IPv4 → Properties`

**Local admin password**, set via PowerShell before continuing the promotion wizard (a strong password is required to proceed):

```powershell
net user Administrator "<placeholder-password>"
```

**Forest/domain creation:**
- New forest, since this is the first and only domain: `homelab.local`
- Forest functional level: **Windows Server 2025**: the only DC in this lab, so no need to support older functional levels.

---

## Challenges & Troubleshooting

### Problem 1 — Weak password blocked the promotion wizard
The wizard threw an error partway through DC promotion because the Administrator account didn't have a strong-enough password set. Fixed by cancelling the wizard and setting the password directly via PowerShell (`net user Administrator "..."`) before retrying.

### Problem 2 — DHCP instead of static IP
The wizard flagged that the machine was using DHCP, which is unsuitable for a DC (its address must never change, or every client/DNS lookup pointing to it breaks). Resolved by manually configuring a static IP as shown in the configuration section.

### Problem 3 — Broken trust relationship after renaming post-promotion
After promotion succeeded, the machine was renamed for easier documentation going forward — **after** promotion, not before. On the next login, this error appeared:

> "The security database on the server does not have a computer account for this workstation trust relationship"

**Root cause:** a Domain Controller's identity is tied to its hostname at the time of promotion. Renaming the machine *after* it's already a DC breaks that binding as the domain no longer recognizes it under its new name.

**Fix: recovery via DSRM:**
1. Rebooted into **Directory Services Restore Mode (DSRM)** (via F8 at boot), logging in with the DSRM password set during initial promotion.
2. Force-removed the broken AD DS role via PowerShell:
   ```powershell
   Uninstall-ADDSDomainController -ForceRemoval -LocalAdministratorPassword (ConvertTo-SecureString "<placeholder-password>" -AsPlainText -Force)
   ```
3. Verified no AD DS components remained:
   ```powershell
   Get-WindowsFeature AD-Domain-Services
   ```
4. Found it still listed as installed, so removed it fully:
   ```powershell
   Uninstall-WindowsFeature AD-Domain-Services -Restart
   ```
5. After reboot, confirmed the machine was a clean, non-DC Windows Server again.
6. Confirmed the hostname was correctly set to `DC01` **before** attempting promotion again:
   ```powershell
   Hostname
   ```
7. Re-ran the promotion wizard from scratch, this time with the correct hostname already in place.

---

## Lessons Learned

- **Set name before promotion, never after.** A DC's identity is bound to its hostname at promotion time. This is to be remembered for any future server builds in this lab.
- **DSRM is a legitimate recovery path**, not just a theoretical "break glass" feature. It's proven to be the correct, supported way to force-remove a broken DC role when normal login is unavailable.
- Uninstalling the AD DS *role* (`Uninstall-ADDSDomainController`) and uninstalling the AD DS *Windows feature* (`Uninstall-WindowsFeature AD-Domain-Services`) are two separate steps. Removing the role doesn't necessarily fully clear the feature, worth checking both.
- Static IP and password strength requirements should be handled **before** starting the promotion wizard, not mid-wizard.

---

## Result

A clean Windows Server 2025 installation, correctly hostnamed `DC01`, successfully promoted to the first Domain Controller of a new forest and domain: `DC01.homelab.local`. Verified healthy via `Get-ADDomain`:

![Get-ADDomain output after clean AD DS setup](../screenshots/01-Get-ADDomain-after-Clean-ADDS-setup_.png)

A VM snapshot was saved at this state named `DC01 – Clean AD DS Install – working` as a rollback point before further configuration.

**Next phase:** [OU & Group Design →](./03-ou-design.md)
