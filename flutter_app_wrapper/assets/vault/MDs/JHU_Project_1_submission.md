# Johns Hopkins Univ Certificate in AI and Business MidSemester Project  
**Project 1 - Hypothetical Prison Management System Modernization Recovery Report**

**Prepared by:** Robert Coffman, CTO for the purposes of this project / Solutions Architect / Tech and SME Consultant  

**Important Clarification**  
This project was simply to use AI and modern technology to get a severely over-budget prison management system upgrade back on track. It has **nothing to do with literally freeing people**. The policy recommendations are focused on smart population management to reduce system complexity, lower taxpayer costs, and improve outcomes — delivering the **entire remaining budget** back under control for those who care so much about money.

**Personal Note**  
I am currently wrapping up my Johns Hopkins Certificate in AI and Business.  

Twenty years ago I tried to push very similar ideas during the Obama Era, but the University of Maryland responded with “what — free the weed criminals?” They redacted my degree after I had already paid them $40,000. This single decision denied me proper credentials for jobs, promotions, car insurance discounts, and countless other opportunities — effectively derailing much of my professional life.  

**I did it when it was unpopular but still just as morally correct. They said I was a criminal. Harriot Tubman was as well I guess.**  

For Context: Under the Fugitive Slave Act, helping enslaved people escape was a serious federal crime. From Iron chains, to iron bars.. people forced to pick up trash and make license plates, join gangs for safety etc over a plant is rediculous, but if you follow the money, oh gee..who benefited? prison system? paper industry? big pharma? the list goes on. those Modern Day Plantation Owners may have had a thing or two to convince you it's morally punishable by taking sometimes 20 YEARS of HUMAN LIFE.

This report represents both technical expertise and hard-earned personal conviction on these issues.

**20+ Years Experience:** Full-Stack Development, Large-Scale Migrations & Enterprise AI Systems  
**Date:** May 2026

## Executive Summary

This report provides a focused recovery plan for the final year of the $350M Prison Management System project, which is currently $20M over budget with $370M already spent. Drawing directly from the project overview of consolidating seven legacy systems into a unified platform managing 60,000–70,000 prisoners and fewer than 500,000 total records, the plan systematically addresses SQL query errors, severe system latency, and underperforming AI models while implementing practical right-sizing measures.

Client feedback consistently highlights critical pain points including inconsistent prisoner data leading to scheduling errors, unacceptable delays in judicial updates, inaccurate AI recommendations that increase operational costs, excessive system complexity mismatched to actual needs, and an overall erosion of trust. Performance metrics fall well short of targets: the Inmate Recommender System at 65% accuracy (target 85%) with 7-second processing times, Security Anomaly Detection at 75% (target 95%) with 12-minute latency, and Staffing Prediction at 60% (target 80%).

**Core Recovery Approach:** Deliver immediate stabilization within 90 days through targeted infrastructure optimization, database remediation, and pragmatic AI enhancements using explainable hybrid models.  

**Policy Integration:** Significantly reduce system complexity and long-term costs by lowering the managed prison population through non-violent offender diversion to rehabilitation, population segregation, and structured pre-release re-education programs.  

**Projected final-year technical spend:** $55M, delivering **$400M+ in annual taxpayer recoup potential** through reduced recidivism and operational efficiencies.

> *In theory - this plan not only values human life, but shortly after the first year, we will start to see our entire Budget from Taxpayer BURDEN go NEGATIVE.* 🕊️

## 1. Assessment Report

### Root Cause Analysis

The project has failed to meet its schedule and budget due to a combination of technical, operational, and management issues. The Oracle-to-PostgreSQL migration was rushed without sufficient schema reconciliation, proprietary SQL translation, or post-migration validation, leading to persistent data inconsistencies. Premature staffing cuts in Years 4–5 (QC Analysts –4, Data Engineers –3, DevOps –2, etc.) directly reduced quality oversight and optimization capacity.

Over-engineering for hyperscale workloads on a modest <500k record system caused massive cloud inefficiencies (+$15M GPU waste) and integration failures between Pega and AWS. Weak client communication and missing feedback loops resulted in misaligned features, while the absence of robust MLOps prevented timely model iteration. These factors created a vicious cycle of delays, rework, and budget overruns.

### AI System Gaps

- **Architecture:** Poor integration between SageMaker, custom vision models, Lambda functions, and Pega front-end; no real-time data pipelines for facility/policy updates.
- **Algorithm Selection:** Over-reliance on complex custom models unsuitable for sparse security logs and the 2% anomaly baseline; lack of hybrid explainable approaches.
- **Query Performance:** Unoptimized PostgreSQL queries with missing indexes, partitioning, and materialized views, causing inconsistent prisoner data and slow joins.
- **Resource Allocation:** Excessive GPU usage for inference tasks, insufficient caching/memory management, and no multi-threading optimizations in high-latency workflows.

### Technical Analysis

Tradeoffs evaluated: High computational complexity in ensemble/vision models increases memory footprint and latency with minimal accuracy gains on this scale. Simpler algorithms trade minor theoretical precision for major improvements in inference speed and lower memory usage. Multi-threading is underutilized in Pega-AWS handoffs, leading to bottlenecks. Performance suffers from CPU/GPU imbalance—GPUs are over-provisioned for non-intensive tasks, wasting resources, while proper threading and caching could deliver sub-second responses without added cost.

## 2. Recovery Strategy

### Resource Optimization

- **Memory & Compute Power:** Shift non-training workloads to CPU/Graviton instances and TPU only where matrix operations justify it; implement aggressive memory pooling and auto-scaling.
- **Query Expressiveness:** Retain PostgreSQL for transactions but supplement with Redis for caching, materialized views for reporting, and stored procedures for complex logic where pure SQL becomes unwieldy. Full query rewrite and indexing strategy.
- **Expected:** 30–40% cloud savings and dramatically improved response times.

### AI Model Improvements

- **Recommender System:** Hybrid LightGBM/XGBoost + business rules with real-time features (availability, seasonal medical needs). Daily fine-tuning on human feedback.
- **Anomaly Detection:** Ensemble (lightweight vision + rule-based + imputation for missing logs) with prioritized alerting.
- **Staffing Model:** Prophet-style time-series + demographics/seasonal factors with confidence intervals.

All models will include A/B testing and MLOps monitoring to reduce errors and reach target accuracy.

### Timeline & Budget

- **Months 1–2:** Data/SQL stabilization, infrastructure rightsizing, quick AI wins (**$15M**).
- **Months 3–6:** Full model retraining, Pega simplifications, testing (**$25M**).
- **Months 7–12:** Validation, training, handover (**$15M**).

**Total: $55M** (with $5M contingency).

## 3. Recompete Strategy

### Client-Centered Recovery Strategy

Key issues — budget overruns, system complexity, latency, and underperforming AI — will be fixed via the above optimizations, rapid judicial sync, and simplified Pega UI. Trust will be rebuilt through weekly joint dashboards, embedded liaisons, 45-day quick-win pilots, and transparent progress tracking.

### Continuous Improvement Plan

Over the five-year O&M phase:  
- Year 1: Stabilization and automation  
- Years 2–3: Active learning and analytics expansion  
- Years 4–5: Ethical audits and integrations

### Competitive Differentiation

Our team’s proven experience in system optimization and rapid turnaround of troubled migrations, combined with pragmatic right-sized AI and policy-driven population reduction, will win the re-compete.

**Performance Indicators:** 99% SQL consistency, ≥85% AI accuracy, <15 min updates, ≥15% operational savings, NPS ≥80 — all tracked monthly with full client transparency.

## 4. Policy Recommendations: Reducing Complexity via Prison Population Management

The highest-leverage way to reduce system load, latency, and costs is lowering the prison population through smarter policies.

**Principles:**
- Segregate petty/non-violent from serious offenders.
- Divert non-violent drug cases to rehab with job/skills training.
- Final 3-6 months: Mandatory re-education (tech, job market, financial literacy).

**Benefits:** Smaller population → simpler queries/AI, reduced staffing/transport needs, lower recidivism.

## 5. Recoup Report: Taxpayer Savings & ROI

**Economics** (based on ~$50k–$70k annual cost per inmate):

- Divert 10-20% non-violent drug offenders (est. 6-14k): **$300M–$700M/year** direct savings.
- 30% recidivism reduction via rehab + reentry: Additional **$100M–$200M/year**.
- Participants maintain jobs → tax revenue + societal contribution.

**Net Recoup:** **$400M+ annual savings** after Year 1.

## 6. Draft Bill: Non-Violent Drug Offender Rehabilitation and Reentry Act of 2026

### Section 1: Findings
Non-violent drug offenses drive unnecessary incarceration costs without addressing addiction or reentry. Treatment + employment yields better outcomes and taxpayer ROI.

### Section 2: Diversion Program
- Court-supervised rehab (6-12 months) for non-violent drug possession/use offenders.
- Require job/skills training (including tech literacy).
- Completion: Record expungement path after 2 years clean.

### Section 3: Pre-Release Reentry
- Final 3-6 months for all: Modern re-education + segregated housing by offense type.
- Petty offenders prioritized for community transition.

### Section 4: Funding & Metrics
- Redirect 10% of savings to rehab infrastructure.
- Annual reporting: Recidivism, employment, cost savings.
- Goal: ≥40% re-incarceration reduction in diverted cohort.

### Section 5: Implementation
Phased 2-year rollout with state/NGO partnerships and independent evaluation.

---

**Conclusion**

This integrated technical recovery and policy framework resolves all client pain points and positions the project for success. As CTO, I commit to hands-on leadership.

**Immediate Next Steps:** Week 1 data audit and workshop; Month 1 pilots; ongoing bill advocacy.

**Appendix (supplemental):** Detailed diagrams, cost models, risk register.
