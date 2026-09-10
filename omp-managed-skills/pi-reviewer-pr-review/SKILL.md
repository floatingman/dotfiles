---
name: pi-reviewer-pr-review
description: "Use whenever reviewing a pull request (own or others') — produce pi-reviewer-format findings: severity-tiered inline comments anchored to verified file line numbers on the PR head branch, plus a summary."
---

# PR reviews in pi-reviewer format

The user's `pi-reviewer` tool (source `~/git/pi-reviewer`, prompt in `src/core/prompt-builder.ts`) defines the required review output format. Never deliver a prose-only review.

## Severity tiers

- 🔴 **CRITICAL**: bugs causing runtime failures, security vulnerabilities, data loss risks
- 🟡 **WARN**: type errors, missing error handling, logic issues, test gaps
- 🔵 **INFO**: style, naming, performance hints, suggestions

## Rules

- Only flag what is actually wrong in the diff — no hypotheticals.
- If nothing is wrong, say so clearly.
- Do not repeat what the project's conventions (AGENTS.md/CLAUDE.md/REVIEW.md of the target repo) already enforce.
- Fetch existing review threads/comments first (`gh pr view --reviews`, `gh api repos/.../pulls/N/comments`) and do not duplicate other reviewers' already-addressed findings; verify their reported fixes instead.
- Verify every claim against the code before flagging (fetch the referenced files, trace cross-repo contracts).

## Deliverable per PR

1. **Summary** — Markdown bullets (bold, `code spans`), severity-marked, including what was verified as already fixed/correct so it isn't re-litigated.
2. **Inline comments** — one block per finding:
   - `path/from/repo/root:LINE` (**side**, 🔴/🟡/🔵 tier)
   - Side: `RIGHT` for added/context lines, `LEFT` only for removed lines.
   - Body: self-contained Markdown comment ready to paste as a GitHub inline review comment, with a concrete suggested fix (code snippet where possible).

## Line-number discipline

- Line numbers are **file line numbers on the PR head branch**, never diff positions.
- Resolve them by fetching actual files: `gh api repos/<head-owner>/<repo>/contents/<path>?ref=<head-ref>` (head is often a fork — get it via `gh api repos/<base>/pulls/N --jq '.head.repo.full_name + " " + .head.ref'`) or `git fetch <url> pull/N/head` + `grep -n`.
- Group identical findings across files/occurrences into one comment listing all anchor lines.

## Workflow

1. Enumerate PRs awaiting review (`gh search prs --review-requested=@me` or per-repo).
2. Fetch diffs (`gh pr diff`), metadata, and prior review threads in parallel.
3. Read diffs fully; verify anchors and cross-repo contracts.
4. Emit summary + inline comments.
5. **Never post anything to GitHub unless the user explicitly asks.**
6. When the user asks to open PRs in tabs in herdr: `herdr tab create --workspace $HERDR_WORKSPACE_ID --label <short> --cwd $PWD --env GH_PAGER=cat --no-focus`, then `herdr pane run <pane-id> 'gh pr view <N> -R <repo> --comments'`.
