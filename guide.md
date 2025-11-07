# Azure Sentinel SOC - Step-by-Step Guide

## Overview
This is a practical guide to create a cloud-native Security Operations Center (SOC) using Microsoft Azure and Microsoft Sentinel. It covers resource creation, VM onboarding, Sentinel configuration, KQL analytics, playbooks, dashboards, and testing.

## Prerequisites
- Azure subscription (trial/Student/paid)
- Azure CLI (optional)
- Basic Azure Portal familiarity

## Steps

### 1. Resource Group & Log Analytics Workspace
1. Portal: Search **Resource groups** → Create → name `SOC-Lab`.
2. Portal: Search **Log Analytics workspaces** → Create → name `SOC-Logs` → Link to `SOC-Lab`.

### 2. Deploy a VM
1. Portal: Search **Virtual machines** → Create → pick Ubuntu or Windows Server.
2. Choose size (e.g., Standard_B1s).
3. Place VM in `SOC-Lab`.

### 3. Connect VM to Log Analytics
1. Go to `SOC-Logs` → **Agents management**.
2. Download agent (Windows or Linux).
3. Install agent on VM using Workspace ID & Primary Key (see `install_agent.ps1`).

### 4. Enable Microsoft Sentinel
1. Search **Microsoft Sentinel** → Add → select `SOC-Logs`.

### 5. Configure Data Connectors
- In Sentinel → Configuration → Data connectors.
- Enable: Azure Activity, Security Events (Windows), Syslog/CEF if needed.

### 6. Add Threat Intelligence
- Sentinel → Threat intelligence → connect Microsoft TI or external feeds like AlienVault OTX.

### 7. Create Analytics Rules (examples in `kql_examples.txt`)
- Create Scheduled Rule → paste KQL (ex: brute force rule).

### 8. Create Playbook (Logic Apps)
- Sentinel → Automation → Add Playbook → Create Logic App.
- Use `logicapp_playbook.json` as a skeleton.

### 9. Build Workbooks / Dashboards
- Sentinel → Workbooks → Create visuals (failed logins, top IPs, incidents).

### 10. Testing & Validation
- Simulate failed logins or create an account to trigger alerts.
- Confirm alerts and that playbooks run.

### 11. Cleanup
- Delete resource group:
```bash
az group delete --name SOC-Lab --yes --no-wait
