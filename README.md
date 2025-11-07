# Azure-Sentinel-SOC

---

## Project summary
This repo contains a hands-on, end-to-end SOC lab built on Microsoft Azure. It shows how to collect logs from Azure VMs, run detections with **Microsoft Sentinel** (KQL), enrich alerts with threat intelligence, automate responses with **Logic Apps**, and visualize incidents with Sentinel Workbooks. The content is designed for learning, portfolio demos, and interview walkthroughs.

---

## What’s included
- `guide.md` — step-by-step implementation guide (Portal + CLI).  
- `kql_examples.txt` — ready-to-use KQL detection queries.  
- `azure_cli_snippets.sh` — CLI commands to bootstrap RG, workspace, VM, and agent extension.  
- `install_agent.ps1` — PowerShell snippet to install Log Analytics agent on Windows VM.  
- `logicapp_playbook.json` — sample Logic App (playbook) skeleton for automated response.  

---

## Prerequisites
- An **Azure subscription** (free trial / Azure for Students / paid).  
- Azure Portal access and permissions to create Resource Groups, VMs, and Logic Apps (Contributor/Owner).  
- (Optional) Azure CLI installed locally / use Azure Cloud Shell.  
- Basic comfort with Azure Portal and accounts.

---

## How to run — Quick overview (Portal method)
> Use the Portal if you prefer a guided UI flow. Steps are written in the order you’ll perform them.

1. **Create Resource Group**
   - Portal → *Resource groups* → Create → `SOC-Lab` (choose region).

2. **Create Log Analytics Workspace**
   - Portal → *Log Analytics workspaces* → Create → Name: `SOC-Logs` → Put it in `SOC-Lab`.

3. **Deploy a VM**
   - Portal → *Virtual machines* → Create → Choose Windows Server 2022 or Ubuntu 22.04, size `Standard_B1s` for learning.
   - Put VM in resource group `SOC-Lab`, open ports for SSH (Linux) or RDP (Windows) if you intend to connect.

4. **Onboard VM to Log Analytics**
   - Portal → *Log Analytics workspaces* → Select `SOC-Logs` → *Agents management*.
   - Download the Windows agent (or use Linux extension). Copy Workspace ID and Primary Key.
   - Install agent on VM:
   - Windows: run the MSI or use `install_agent.ps1`.
   - Linux: use the recommended extension or agent package.

5. **Enable Microsoft Sentinel**
   - Portal → *Microsoft Sentinel* → Add → Choose `SOC-Logs` workspace → Add.

6. **Configure Data Connectors**
   - In Sentinel → *Configuration* → *Data connectors*. Enable:
     - Azure Activity
     - Security Events (Windows)
     - Syslog / CEF if you have other sources
     - Threat Intelligence connector(s) (Microsoft, AlienVault OTX, etc.)
     - Follow the on-screen single-click steps for each connector.

7. **Create Analytics Rules (KQL)**
   - Sentinel → *Configuration* → *Analytics* → Create -> Scheduled rule.
   - Use queries from `kql_examples.txt` (e.g., repeated failed logins).
   - Configure severity, MITRE ATT&CK mapping, and frequency.

8. **Add Playbook (Logic App)**
   - Sentinel → *Automation* → Add *Playbook* → This opens Logic Apps designer.
   - Create a new Logic App with trigger “When a response to an Azure Sentinel alert is triggered.”
   - Use the `logicapp_playbook.json` as a starting template or build UI actions (send email, create ticket).

9. **Build Workbooks & Dashboards**
   - Sentinel → *Workbooks* → Create → Add visualization: Top failed logins, incidents by severity, top source IPs.
   - Save workbook and pin to your Azure Dashboard.

10. **Test the pipeline**
    - Simulate events: perform several failed logins, create a local account, or generate syslog entries.
    - Check that logs appear in the Log Analytics workspace and that alerts/incidents are created in Sentinel.
    - Ensure playbooks run when alerts fire (check Logic Apps runs history).

---

## How to run — CLI (scripted / repeatable)
> Replace placeholders (`<...>`) before running.

```bash
# 1. Login
az login

# 2. Create resource group
az group create --name SOC-Lab --location eastus

# 3. Create Log Analytics workspace
az monitor log-analytics workspace create --resource-group SOC-Lab --workspace-name SOC-Logs

# 4. Create a VM (example: Ubuntu)
az vm create --resource-group SOC-Lab --name soc-vm --image UbuntuLTS --admin-username azureuser --generate-ssh-keys --size Standard_B1s

# 5. Get workspace ID (customerId) and set the agent extension (replace <PRIMARY_KEY>)
WORKSPACE_ID=$(az monitor log-analytics workspace show --resource-group SOC-Lab --workspace-name SOC-Logs --query customerId -o tsv)
az vm extension set --publisher Microsoft.Azure.Monitor --name OmsAgentForLinux --resource-group SOC-Lab --vm-name soc-vm --settings "{\"workspaceId\":\"$WORKSPACE_ID\"}" --protected-settings "{\"workspaceKey\":\"<PRIMARY_KEY>\"}"

```

After the CLI steps, enable Sentinel via Portal (or ARM/template) and create KQL rules via portal or API.

---

## Testing & validation (what to check)

- Logs appear in the Log Analytics workspace (search with Log Analytics → Logs).
- Analytics rule triggers and creates an alert/incident (Sentinel → Incidents).
- Playbook runs and sends the configured output (check Logic Apps run history).
- Workbooks show updated visualizations based on test events.

---

## Cost & cleanup

- Cost: small VMs and log ingestion may incur charges. Use Standard_B1s or free/credit accounts and limit data retention.
- Cleanup: delete the resource group to remove all resources:
```bash
az group delete --name SOC-Lab --yes --no-wait
```
