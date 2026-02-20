# Rules for Claude Code (z.ai Environment)

**Last Updated**: 2026-02-19
**Priority**: CRITICAL

## Quick Reference

| Token/MCP Usage | Action | Check Interval |
|-----------------|--------|----------------|
| 🟢 0-60% | Normal operation | 10 min |
| 🟡 60-80% | Prefer safe tools (Read/Glob/Grep), confirm before Task/WebSearch/Skill | 5 min |
| 🔴 80%+ | **STOP** - only Read/Glob/Grep/TaskList/TaskGet/AskUserQuestion allowed | N/A |

Check quota: `node ~/.claude/skills/usage-query-skill/scripts/query-usage.mjs | grep percentage`

## Safe Tools (Always Allowed)

**No API tokens**:
- `Read`, `Glob`, `Grep`, `TaskList`, `TaskGet`, `AskUserQuestion`

**Bash** (STRICT WHITELIST - see full list below):
- Read-only: `ls`, `cat`, `head`, `tail`, `stat`, `file`, `wc`, `find`, `tree`, `pwd`
- Write: `mkdir`, `touch`, `cp`, `mv`, `tee` (only `/home/ec2-user/`)
- System: `date`, `uptime`, `whoami`, `id`, `uname`, `df`, `du`, `ps`, `env`
- Network: `curl`, `wget`, `git` (within workspace), `ssh`, `scp`
- Package: `npm`, `yarn`, `pnpm`, `pip`, `pip3`, `yum`, `dnf`, `gem` (user-level only)

**Never use**: `rm`, `dd`, `shutdown`, `sudo`, `kill`, `chmod 777`, `chown`, `apt`, `crontab -e`, or patterns like `| sh`, `$(...)`, backticks, `eval`

## MCP Servers

1. **4-5v-mcp** (analyze_image) - HIGH impact, requires confirmation
2. **web-reader** (webReader) - MEDIUM impact, no confirmation needed

MCP quota (1-month) has same thresholds as token quota.

## Environment

- API base: `https://api.z.ai/api/anthropic`
- Bot workspace: `~/clawd/`
- Projects: `~/claudeCodeProject/`
- Timezone: NZDT (UTC+13)
- Language preference: Python

For detailed rules, see:
- `~/.claude/config/tool-whitelist.json` - Full bash command whitelist
- Project-specific `CLAUDE.md` files
