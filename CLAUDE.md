# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A collection of custom Claude Code agent definitions (`.md` files with YAML frontmatter) designed for iOS/Swift/SwiftUI projects. These agents are installed to `~/.claude/agents/` and become available as specialized subagents in Claude Code conversations.

## Installation

```bash
./install.sh
```

This copies all `.md` agent files to `~/.claude/agents/`.

## Architecture

Each agent file follows this structure:
- **YAML frontmatter** (`---` delimited): `name`, `description` (triggers delegation), `tools` (available tool list), `model` (typically `inherit`)
- **Markdown body**: System prompt defining the agent's role, rules, checklists, and output format

### Agents

| Agent | Purpose | Tools | Writes Code |
|-------|---------|-------|-------------|
| `architect` | Architecture review, SOLID principles, layer boundaries, design proposals | Read, Grep, Glob, Bash | No |
| `code-reviewer` | Code quality, security, memory/concurrency bugs, pre-PR checks | Read, Grep, Glob, Bash | No |
| `tester` | Unit test generation, test review, mock/stub creation | Read, Grep, Glob, Bash, Edit, Write | Yes |
| `ui-designer` | SwiftUI views, design systems, animations, accessibility, performance | Read, Grep, Glob, Bash, Edit, Write | Yes |
| `maintenance` | Dead code, deprecated APIs, tech debt, dependency audit, build hygiene | Read, Grep, Glob, Bash | No |
| `marketing` | App Store optimization, ad copy, competitor analysis, growth strategy | Read, Grep, Glob, Bash, Edit, Write | Yes (marketing content) |

### Cross-Agent Delegation

Agents reference each other for handoffs: architect flags untestable code → tester. code-reviewer finds architectural violations → architect. maintenance finds deprecated SwiftUI APIs → ui-designer. marketing consults architect for feature scope and ui-designer for screenshot polish. This delegation pattern is intentional and consistent across all agents.

### Common Patterns Across Agents

- All agents start with an "Adapt Before You X" section requiring them to read the target project's `CLAUDE.md` first and respect its conventions over generic rules.
- All agents use a severity-tiered output format (CRITICAL/WARNING/SUGGESTION or equivalent).
- The `architect`, `code-reviewer`, and `maintenance` are read-only (no Edit/Write tools). The `tester`, `ui-designer`, and `marketing` can write files.
- The technical agents (architect through maintenance) target iOS/Swift/SwiftUI specifically, with detailed coverage of modern APIs (Swift 6.2, iOS 17+, `@Observable`, structured concurrency). The `marketing` agent is Pixara-specific and focuses on App Store optimization and growth.

## Editing Guidelines

When modifying agent prompts:
- Keep the YAML frontmatter `description` field accurate — it controls when Claude Code delegates to the agent.
- Maintain the "Adapt Before You X" pattern — agents must defer to target project conventions.
- Keep the zero-false-positives philosophy — agents should verify findings before reporting.
- The `tools` field in frontmatter must match what the agent actually needs. Read-only agents should not have Edit/Write.
