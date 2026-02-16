# TOOL WHITELIST RULE

**Created**: 2026-02-15
**Priority**: HIGH
**Configuration**: `~/.claude/config/tool-whitelist.json`

## Purpose

Defines safe tools, MCP servers, and actions for quota-conscious operations. This rule ensures safe tool usage during high quota periods and prevents automated scripts from consuming excessive quota.

## Safe Tools (Exempt from Quota Restrictions)

The following tools are **always safe** and don't consume API tokens:
- **Read**: Read files from filesystem
- **Glob**: Pattern-based file searching
- **Grep**: Content searching with ripgrep

Conditionally safe (minimal token cost):
- **AskUserQuestion**: Safe when gathering requirements
- **TaskList**: Safe for task tracking
- **TaskGet**: Safe for retrieving task details
- **Bash**: **STRICT MODE** - Only commands listed in `safeBashCommands` section of config

Never safe during high quota:
- **Task**: Agent spawning
- **WebSearch**: External API calls
- **Skill**: User-invocable skills
- **Write/Edit**: File modifications

### Safe Bash Commands (STRICT WHITELIST)

**Bash tool is in STRICT MODE**. Only these commands are allowed:

**Read-Only**: `ls`, `cat`, `head`, `tail`, `stat`, `file`, `wc`, `find`, `tree`, `pwd`, `echo`, `printf`
**Write**: `mkdir`, `touch`, `cp`, `mv`, `tee` (only within `/home/ec2-user/`)
**System**: `date`, `uptime`, `whoami`, `id`, `uname`, `df`, `du`, `ps`, `env`
**Network**: `curl`, `wget`, `git`, `ssh`, `scp` (with restrictions)
**Package Managers**: `npm`, `yarn`, `pnpm`, `pip`, `pip3`, `yum`, `dnf`, `gem` (user-level only)

**Strictly Blocked**: `rm`, `dd`, `shutdown`, `sudo`, `kill`, `chmod 777`, `chown`, `apt`, `crontab -e`, and any dangerous patterns like `| sh`, `$(...)`, backticks

See full list in `~/.claude/config/tool-whitelist.json` → `safeBashCommands`

## MCP Whitelist

### Approved Servers

**Image Analysis (4-5v-mcp)**
- Impact: HIGH
- Tool: analyze_image
- Requires confirmation: YES

**Web Reader (web-reader)**
- Impact: MEDIUM
- Tool: webReader
- Requires confirmation: NO

### MCP Quota Awareness

- **Monthly MCP quota** is tracked separately from token quota
- MCP usage (1-month) has same thresholds: 60% warning, 80% stop
- When MCP quota ≥80%, stop ALL MCP tool usage immediately

## Behavior by Quota Level

### 🟢 Green (0-60%)
- All tools available
- No restrictions
- Check quota every 10 minutes

### 🟡 Yellow (60-80%)
- **Prefer safe tools**: Read, Glob, Grep
- **Confirmation required** before: Task, WebSearch, Skill
- Check quota every **5 minutes**
- Avoid spawning multiple agents
- Limit MCP tool usage

### 🔴 Red (80%+)
- **STOP all non-essential work**
- **Only allowed tools**:
  - Read
  - Glob
  - Grep
  - TaskList
  - TaskGet
  - AskUserQuestion
- **Blocked tools**:
  - Bash
  - Task
  - WebSearch
  - Skill
  - Write
  - Edit
  - All MCP tools
- Stop immediately, wait for quota refresh

## Automation Safety Constraints

When executing via **cron jobs** or **hooks**:

### Allowed Operations
- **Read-only**: Read files, list directories, search content, check quota, list/get tasks
- **Limited write**: Write to log files in `~/.claude/logs/`, update task status only

### Blocked Operations (Never Allow)
- Delete files
- Execute arbitrary commands (Bash)
- Make API calls (WebSearch, MCP tools)
- Spawn agents (Task tool)
- Create new tasks

### Resource Limits
- Max 2 concurrent agents
- Max 30 minute task duration
- Quota check required before ANY action
- Stop automation at **75% threshold**

### Agent Type Restrictions
- **Allowed**: Explore, bash agents
- **Requires approval**: general-purpose, Plan agents

## Integration with Quota Monitoring

This whitelist rule works together with the Quota Monitoring Rule:
1. Quota Monitoring Rule determines WHEN to check
2. Tool Whitelist Rule determines WHAT tools are safe at each level

Both rules must be satisfied for any operation to proceed.

## Configuration Updates

To modify this whitelist:
1. Edit `~/.claude/config/tool-whitelist.json`
2. Update version number and date
3. Restart Claude session for changes to take effect

## Emergency Override

If user explicitly requests an action that violates whitelist:
- Ask for confirmation: "This will use [blocked tool]. Quota is at X%. Continue?"
- If user confirms, proceed but log the override
- Do not override at 90%+ quota (critical threshold)
