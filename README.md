# Azure-Sentinel-SOC
Build a fully functional cloud-based Security Operations Center (SOC) using Microsoft Azure Sentinel, Log Analytics, and Logic Apps for real-time threat detection, analysis, and automated incident response.

---

## What this repo contains
- `guide.md` — step-by-step implementation guide in markdown.
- `Azure_Sentinel_SOC_Complete_Guide.pdf` — (optional) full printable guide in PDF.
- `kql_examples.txt` — paste-ready Kusto Query Language (KQL) rules for detections.
- `azure_cli_snippets.sh` — Azure CLI snippets to create RG, workspace, VM, and agent extension.
- `install_agent.ps1` — PowerShell helper to install Log Analytics agent on Windows VM.
- `logicapp_playbook.json` — skeleton Logic App playbook for automated responses.
- `docs/` — screenshots and an example incident report.

---

## How to run (quick)
1. Create an Azure subscription (free / student if available).  
2. Follow `guide.md` step-by-step (Portal or CLI).  
3. Use `kql_examples.txt` to add analytics rules in Sentinel.  
4. Import `logicapp_playbook.json` into Logic Apps if you want automated responses.  
5. Test by generating failed logins or other benign events on the onboarded VM.

---
