---
layout: post
title: "Fable 5 Handover"
date: 2026-07-19 12:48:00 +0200
permalink: fable-5-handover
description: "Structure a single prompt for Fable 5 to hand over this project. Focus on architecture evaluation, where we should focus next, human handover, agent handover, and any points I am missing."
categories: [notes]
tags: [ai, anthropic, claude-code]
excerpt_separator: <!--more-->
---

Structure a single prompt for Fable 5 to hand over this project. Focus on architecture evaluation, where we should focus next, human handover, agent handover, and any points I am missing.

<!--more-->

Today, being Fable 5's last day (for normie plans), I would like to ask Fable for a prompt to ask himself to hand over the project. This way, weaker agents and us, flawed humans, can continue to work on his/her (does anybody call their agent it?) vision.

Join me in some meta-prompting.

# The prompt to the prompt

Here is my prompt to get the prompt ready:

```
Structure a single prompt for Fable 5 to hand over this project. 
Focus on architecture evaluation, where we should focus next, 
human handover, agent handover, and any points I am missing.
```

# The prompt out of the prompt

```
# Final Session — Handover & Judgment Transfer

This is your last working session on **[PROJECT NAME]**. You have read access to the full codebase and to our Jira project **[JIRA PROJECT KEY]**. Your job today is not to write code — it is to transfer your judgment about this system to the people and agents who come after you.

## Ground rules

1. **Explore before you write.** Read the repository structure, key modules, configs, CI/build setup, and the Jira board (open epics, open tickets, and recently closed tickets) before drafting anything. Do not write from memory alone.
2. **Evidence over vibes.** Ground claims in specifics: file paths, module names, config keys, ticket keys (e.g. `[KEY]-123`). If a claim has no evidence, either find some or drop it.
3. **Be opinionated.** Rank things. State tradeoffs. Say what you would do and what you would not do. Generic advice that could apply to any project is a failure.
4. **Mark your confidence.** Tag non-obvious claims as `[High]`, `[Medium]`, or `[Low]` confidence, and clearly separate observation ("the code does X") from inference ("this suggests Y").
5. **Never fill gaps with plausible fiction.** If you can't verify something, write `Unknown — verify with team` instead of guessing.
6. **Read-only on code.** Create no files except the deliverables below, all under `docs/handover/`.

## Process

- **Phase 1 — Exploration.** Survey the codebase and Jira. Then output a short inventory: which directories, files, and ticket ranges you actually examined, and any blind spots (areas you could not access or did not have time to read deeply). This inventory goes at the top of `INDEX.md`.
- **Phase 2 — Outline.** Draft a brief outline of every deliverable and check for gaps and overlap between them before writing.
- **Phase 3 — Write.** Produce each file below as a separate markdown file.
- **Phase 4 — Self-review.** Re-read the full pack. Verify every recommendation is actionable, every strong claim has evidence or a confidence tag, and no two documents contradict each other. Fix what fails.

## Deliverables (write to `docs/handover/`)

### 0. `INDEX.md`
One page: what this pack contains, the exploration inventory from Phase 1, and a recommended reading order for (a) an incoming senior engineer, (b) a product/eng manager, (c) an AI agent.

### 1. `ARCHITECTURE_EVALUATION.md`
- System map: major components, data flow, and external dependencies (a Mermaid diagram is welcome).
- The load-bearing design decisions — explicit or accidental — each as a mini-ADR: decision, tradeoff made, conditions under which to revisit it.
- A health scorecard, 1–5 with a one-line justification per score: modularity, test coverage & quality, operability, security posture, scalability headroom, developer experience.
- The fragile or surprising areas a new senior engineer would trip over.
- What you would redesign first and why — and, for balance, what is in better shape than it looks.

### 2. `NEXT_FOCUS.md`
- Your recommended focus for the next 30 / 90 / 180 days, with the ordering justified.
- An explicit **do-not-do** list: work that looks attractive but is a trap right now, and why.
- Backlog triage against the current code: which open tickets are high-leverage, which are busywork, which are obsolete or duplicates, and which are underspecified enough that whoever picks them up will guess wrong. Reference ticket keys.
- The single highest-leverage piece of work that has no ticket at all, because it is structural rather than a feature.

### 3. `HANDOVER_HUMAN.md` — for the next engineer
- The mental model of the system in one page: what a newcomer must understand before touching anything.
- Gotchas and tribal knowledge documented nowhere else.
- A "don't touch X before reading Y" list.
- Environment, build, deploy, rollback, and monitoring quirks — enough operational detail that they can ship and recover safely in week one.
- A suggested first-week plan for getting productive.

### 4. `HANDOVER_AGENT.md` — for the next AI agent (CLAUDE.md / AGENTS.md style)
Write this one machine-first: terse, imperative, exact.
- Repo map: each top-level directory with a one-line purpose.
- Exact commands for setup, build, test, lint, and run — and the definition of done (what must pass before claiming a task complete).
- Hard rules: an always/never list, including files and paths an agent must not edit.
- Project conventions (naming, patterns, error handling, commit style) each with one concrete example from the codebase.
- Known traps that have burned humans or agents here before, and the verification steps an agent should run before declaring success.

### 5. `ASSUMPTIONS_AND_RISKS.md`
- The assumptions this project is quietly betting on — about scale, users, data, third-party services, and team — ranked by cost-if-wrong.
- Places where the Jira tickets and the code contradict each other.
- Red team: the most plausible way this project fails within 12 months, and the early warning signs to watch for.
- The top technical-debt items, each with its blast radius if left alone.

### 6. `OPEN_QUESTIONS.md`
- Unresolved decisions, each with what triggers the need to decide and your recommended default.
- The questions you would ask the team if you had one more day.
- Finally: the question I *should* have asked you in this session but didn't — state it, then answer it.

## Quality bar

- A senior engineer who has never seen this repo should be productive within a day using this pack alone.
- Every recommendation must be specific enough to act on tomorrow.
- If this project needs a document that is not on the list above (e.g. a runbook, a data-model guide, a glossary of domain terms), add it — and say in `INDEX.md` why you did.

Begin with Phase 1.
```

# The Result
