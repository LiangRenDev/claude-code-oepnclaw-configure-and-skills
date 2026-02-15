#!/bin/bash
# Daily News Fetcher & Sender - Runs at 8am NZDT (7pm UTC)
# Fetches news, generates report, and sends to Telegram

SKILL_DIR="/home/ec2-user/.claude/.agents/skills/news-aggregator-skill"
REPORTS_DIR="$SKILL_DIR/reports"
DATE=$(date +%Y%m%d_%H%M)
TELEGRAM_CHAT_ID="6554119701"

echo "[$(date)] Starting daily news fetch..."

# Create reports directory if it doesn't exist
mkdir -p "$REPORTS_DIR"

cd "$SKILL_DIR"

# Fetch news and save JSON
python3 scripts/fetch_news.py --source all --limit 15 --deep > "$REPORTS_DIR/raw_news_$DATE.json" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "[$(date)] News fetched successfully. Raw data saved to raw_news_$DATE.json"

    # Generate the formatted report
    REPORT_FILE="$REPORTS_DIR/hn_news_$DATE.md"

    # Use OpenClaw CLI to generate and send the report
    # We'll trigger an agent to process the news and send it
    /home/ec2-user/.npm-global/bin/openclaw agent news-aggregator-skill "daily news report" > /dev/null 2>&1

    echo "[$(date)] Report generated"
else
    echo "[$(date)] ERROR: Failed to fetch news"
    exit 1
fi

echo "[$(date)] Daily news fetch completed"
