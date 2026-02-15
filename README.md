# Claude Code & OpenClaw Skills Collection

This repository contains a comprehensive collection of skills, documentation, and configuration files for **Claude Code** and **OpenClaw**.

## 📁 Repository Structure

```
.
├── claude-code-skills/    # Claude Code custom skills
├── openclaw-skills/       # OpenClaw built-in skills
├── openclaw-docs/         # OpenClaw CLI documentation
├── agents.md              # OpenClaw agents management guide
├── preference.md          # Preferences and configuration guide
└── config-examples/       # Configuration file examples
```

## 🤖 Claude Code Skills

Claude Code skills are located in the `claude-code-skills/` directory. These are custom skills that extend Claude Code's capabilities.

### Available Skills

- **usage-query-skill**: Run usage query scripts for GLM Coding Plan

### Adding Custom Skills

To add custom skills to Claude Code:

1. Create a new directory in `~/.claude/skills/your-skill-name/`
2. Include a `skill.md` with skill metadata
3. Add your implementation files

## 🦞 OpenClaw Skills

OpenClaw comes with 50+ built-in skills located in `openclaw-skills/`.

### Categories

- **Authentication**: 1password, apple-notes, apple-reminders
- **Communication**: discord, slack, imsg, telegram
- **Productivity**: notion, obsidian, things-mac, trello
- **Media**: spotify-player, sonoscli, canvas, video-frames
- **Development**: github, coding-agent, tmux
- **AI/ML**: gemini, openai-image-gen, openai-whisper
- **Utilities**: weather, oracle, healthcheck, summarize

### Using OpenClaw Skills

```bash
# List available skills
openclaw skills list

# Get skill details
openclaw skills info <skill-name>

# Enable/disable a skill
openclaw skills enable <skill-name>
openclaw skills disable <skill-name>
```

## 📚 OpenClaw Documentation

### Core Documentation

- **agents.md**: Multi-agent management (workspaces, routing, auth)
- **config.md**: Configuration management (get/set/unset values)
- **setup.md**: First-time setup and initialization
- **configure.md**: Interactive configuration wizard

### Key Concepts

#### Multi-Agent System

OpenClaw supports multiple isolated agents with:
- Separate workspaces
- Independent authentication
- Custom routing rules

#### Configuration

Config is stored in `~/.openclaw/openclaw.json`:

```json5
{
  agents: {
    list: [
      {
        id: "main",
        identity: {
          name: "OpenClaw",
          theme: "space lobster",
          emoji: "🦞",
          avatar: "avatars/openclaw.png",
        },
      },
    ],
  },
}
```

## 🚀 Quick Start

### Claude Code Setup

```bash
# Navigate to Claude Code skills directory
cd ~/.claude/skills/

# Clone or copy skills from this repo
```

### OpenClaw Setup

```bash
# Install OpenClaw
npm install -g openclaw

# Run initial setup
openclaw setup

# Or run the full wizard
openclaw setup --wizard
```

## 📖 Documentation Links

- [OpenClaw Getting Started](https://openclaw.dev/start/getting-started)
- [Multi-Agent Routing](https://openclaw.dev/concepts/multi-agent)
- [Agent Workspace](https://openclaw.dev/concepts/agent-workspace)
- [Claude Code Documentation](https://claude.ai/claude-code)

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This repository collects documentation from various projects. Please refer to individual projects for their specific licenses:

- **Claude Code**: © Anthropic
- **OpenClaw**: See [OpenClaw License](https://github.com/binarylove-lc/openclaw/blob/main/LICENSE)

## 🔗 Links

- [OpenClaw GitHub](https://github.com/binarylove-lc/openclaw)
- [Claude Code](https://claude.ai/claude-code)
- [LiangRenDev GitHub](https://github.com/LiangRenDev)

---

**Last Updated**: 2025-02-15
