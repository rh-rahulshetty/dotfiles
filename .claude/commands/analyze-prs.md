# PR Analysis Skill

Perform a thorough static analysis of all open pull requests in a GitHub repository and produce a prioritized review document.

## Arguments

`$ARGUMENTS` — One of:
- `<owner>/<repo>` — analyze all open PRs in that repo  
- `<owner>/<repo> <output-path>` — same, but write the report to a custom path  
- `<owner>/<repo> <pr1,pr2,...>` — analyze only the listed PR numbers  

If no repo is provided, use the repo for the current git remote (`gh repo view --json nameWithOwner`).  
Default output path: `hack/pr_analysis.md` (relative to the project root).

---

## Your Task

You are doing a code reviewer's job: read the PR description, read the actual diff, and decide whether the change makes sense. Then order all PRs by testing importance and flag anything suspicious.

### Step 1 — Parse arguments

Extract `REPO` and `OUTPUT_PATH` from `$ARGUMENTS`. If repo is missing, detect it from git remote.

### Step 2 — Fetch PR list

```
gh pr list --repo <REPO> --state open --limit 100 \
  --json number,title,author,additions,deletions,changedFiles,updatedAt,labels
```

Note which PRs have `additions <= 5` — these are trivial and you can skip fetching their full diff.

### Step 3 — Fetch descriptions and diffs

For each non-trivial PR, fetch in parallel batches:
```
gh pr view <N> --repo <REPO> --json number,title,body,author,additions,deletions,changedFiles
gh pr diff <N> --repo <REPO>
```

For trivial PRs, fetch only the description (no diff needed).

### Step 4 — Analyze each PR

For every PR evaluate:

1. **Description ↔ Diff match** — Does the diff actually do what the description says? Flag mismatches.
2. **Fix validity** — Is the logic in the diff correct? Look for:
   - Off-by-one errors, wrong variable names, inverted conditions
   - Broad `except Exception` where specific exceptions are warranted
   - Systemic errors that should fail fast being silently swallowed
   - Missing edge case guards
3. **Scope creep / bundling** — Does this PR fix multiple unrelated things? Prefer focused PRs.
4. **Duplicates / overlap** — Are multiple PRs fixing the same root cause? Identify the best implementation among them.
5. **Conflict risk** — Does this PR touch the same files as other open PRs in ways that will cause merge conflicts?
6. **Test coverage** — Does the description mention tests? Are tests present in the diff?

### Step 5 — Classify each PR

Assign one of:
- ✅ **Merge** — Valid, focused, correct, low risk
- ✅ **Test** — Valid but needs manual cluster/integration testing before merge
- ⚠️ **Test carefully** — Valid but high regression risk (large refactor, behavior change)
- ❌ **Reject / Rework** — Wrong approach, broad exception handling, broken premise, or introduces bugs
- ❌ **Superseded** — Another open PR fixes the same thing better
- ❌ **Defer** — Too large/risky for current cycle; needs its own review window
- ❌ **Stale** — Marked stale or conflicts with too many other open PRs

### Step 6 — Identify cross-cutting patterns

Look across all PRs for:
- **Duplicate root causes** — N PRs fixing the same bug; pick the best, note superseded ones
- **Bundle anti-pattern** — PRs that should be split
- **Exception handling anti-patterns** — Broad `except Exception` that swallows systemic errors
- **The best-of-N rule** — When duplicates exist, explain which is best and why

### Step 7 — Write the report

Write a structured markdown file to `OUTPUT_PATH` with:

```markdown
# PR Analysis — <REPO>

> Date: <today>
> Open PRs reviewed: <N>

---

## Quick Reference Table

| PR | Action | Reason |
|----|--------|--------|
| #N | ✅/⚠️/❌ Label | One-line reason |

---

## Priority 1 — Merge First
(PRs that should go in first because others depend on them or they fix the most critical bugs)

### #N — <title>
**Author:** ... | +X/-Y, Z files

**Description match:** ✅/❌ <one sentence>

**Fix validity:** <analysis — what the diff does, whether the logic is correct, edge cases>

**Conflicts / dependencies:** <any open PRs this conflicts with>

**Verdict:** <merge / reject / etc and why>

---

## Priority 2 — Correctness Improvements
...

## Priority 3 — New Features (Test Thoroughly)
...

## Priority 4 — High Risk / Needs Dedicated Review
...

## Reject / Rework / Defer
...

## Superseded PRs (Close Without Merging)
| PR | Superseded By | Reason |
...

---

## Cross-Cutting Patterns Found
(Duplicate root causes, bundle issues, anti-patterns spotted across multiple PRs)
```

Make the analysis specific and actionable — not just "looks good" but concrete observations about the diff logic, variable names, exception types, and how the fix interacts with other code.

Save the file and then print a short summary to the user: how many PRs reviewed, how many in each category, and the top 5 to test first.
