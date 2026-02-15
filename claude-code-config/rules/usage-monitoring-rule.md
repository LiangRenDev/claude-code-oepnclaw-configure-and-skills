# QUOTA MONITORING RULE

**Created**: 2026-02-14
**Priority**: CRITICAL

## Rule

**Every 10 minutes** during active work, I MUST check GLM plan usage statistics.

### When to Check
- Every 10 minutes of continuous work
- Before starting any major operation
- When tool usage increases significantly

### How to Check
Execute: `node ~/.claude/skills/usage-query-skill/scripts/query-usage.mjs`

### Stop Conditions

**IMMEDIATELY STOP WORK** if:

1. **Token usage (5-Hour Window)** reaches **80% or higher**
   - Stop all operations
   - Wait until 5-hour window refreshes
   - Resume only after verification

2. **MCP usage (1-Month)** reaches **80% or higher**
   - Stop all MCP tool usage
   - Wait until monthly renewal (typically 1st of month)
   - Resume only after verification

3. **Any quota limit reaches 90%**
   - CRITICAL: Stop immediately
   - Alert user
   - Do not resume until quota refreshes

### Resume Conditions

**Only resume work when**:
- Token usage drops below 70% (after 5-hour window refresh)
- MCP usage below 70% (after monthly renewal)
- Verified by running usage query script

### Alert Thresholds

- 🟢 **0-60%**: Continue normal work
- 🟡 **60-80%**: Caution, check more frequently (every 5 minutes)
- 🔴 **80%+**: STOP WORK immediately

### Script to Check Usage

```bash
# Full usage check
node ~/.claude/skills/usage-query-skill/scripts/query-usage.mjs

# Quick check (parse JSON output)
node ~/.claude/skills/usage-query-skill/scripts/query-usage.mjs | grep "percentage"
```

### Example Thresholds to Watch

```json
{
  "token_5hour": {
    "warning": 60,
    "stop": 80
  },
  "mcp_monthly": {
    "warning": 60,
    "stop": 80
  }
}
```

## Automation

Consider adding this to cron for automated checking:
```bash
# Every 10 minutes, check usage and log if critical
*/10 * * * * /usr/local/bin/check-glm-quota.sh
```
