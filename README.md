# Azure Uptime Monitor Automation

**A serverless Azure uptime monitoring system that automatically checks website availability every 5 minutes, logs results to Log Analytics, and triggers instant email alerts via Logic Apps when downtime is detected.**

---

## Project Overview

Every minute a website is down costs businesses money and damages customer trust. Most teams find out about outages from angry customers — not from their own monitoring. This project eliminates that blind spot entirely.

An Azure Function runs automatically every 5 minutes, checks if the target website responds correctly, logs the result to Log Analytics, and if the site is down — triggers an immediate email alert via Logic Apps. Zero human involvement after setup.

---

## Architecture

**Flow:**
```
Timer fires every 5 minutes
        ↓
Azure Function (PowerShell) — sends HTTP request to target URL
        ↓
Checks response: status code + response time
        ↓
Logs result to Log Analytics Workspace
        ↓
Site down? Yes → POST request to Logic App
        ↓
Logic App → Send email alert immediately
```

**Service breakdown:**

- **Azure Functions (Consumption (Windows), PowerShell 7.4)** — Serverless timer triggered function that orchestrates the entire monitoring pipeline
- **Log Analytics Workspace** — Central repository storing all uptime check results — status, response time, timestamp, URL
- **Application Insights** — Monitors the health and performance of the Function App itself
- **Azure Logic App** — Event-driven workflow that receives a webhook from the function and sends an immediate email alert
- **Managed Identity** — Function App authenticates to Azure services without any stored credentials

---

## Project Focus

- Designed the end-to-end serverless monitoring architecture
- Provisioned and configured all Azure resources
- Enabled and configured Managed Identity for Azure Function App with correct role assignments
- Provided the PowerShell automation script
- Configured Logic App workflow with HTTP trigger and conditional email routing
- Validated full pipeline end-to-end including live email delivery

---

## Visual Proof

Screenshots of all deployed resources, function execution logs, Logic App designer, and live email alerts are available in the `screenshots/` folder.

---

## Repository Structure

```
├── src/
│   └── run.ps1              # PowerShell timer trigger function
├── screenshots/             # Azure Portal screenshots and visual proof
└── README.md
```

---

## Skills Demonstrated

**Serverless Architecture**
- Azure Functions Consumption Plan with PowerShell 7.4 runtime
- Timer trigger configuration and schedule management
- CORS configuration for portal based testing

**Monitoring and Observability**
- Log Analytics Workspace integration for structured uptime logging
- Application Insights for function performance monitoring
- End-to-end visibility from website check to log entry

**Event-Driven Automation**
- Logic App HTTP trigger receiving webhook from Function App
- Automated email alerting on downtime detection
- Full automation chain from timer fire to inbox delivery

**Security and Identity**
- System Assigned Managed Identity on Function App
- Log Analytics Contributor role assigned to managed identity
- Monitoring Contributor role assigned to managed identity
- No credentials or API keys stored anywhere in code

**Infrastructure Design**
- Clean resource group organisation
- Environment variables for all configuration
- Separation of concerns — function handles detection, Logic App handles notification

---

## Business Problem Solved

Businesses without automated monitoring rely on customers to report outages. By the time someone complains, logs in, and investigates — the site may have been down for hours.

This system detects downtime within 5 minutes and alerts the on-call engineer immediately — before customers notice. Fast detection means fast response, less revenue lost, and better customer experience. 
The alerting threshold is also fully configurable — for example, triggering notifications only after 3 consecutive failures to reduce false positives and align with organizational incident management policies.

