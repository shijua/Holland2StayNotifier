A simple bot that sends new published houses in Holland2Stay to Telegram groups.

## Installation:
```bash
git clone https://github.com/JafarAkhondali/Holland2StayNotifier.git
cd Holland2StayNotifier/h2snotifier
python3 -m venv venv
source venv/bin/activate

cp config_example.json config.json 
cp env_example .env 
# Update config.json and .env with you desired chat group and telegram bot

pip install -r requirements.txt

# Test one-time
python main.py
```

## Demo:
Simply join the Telegram group, the bot posts new houses(Direct links removed to prevent spammer):    
The Hague, Amsterdam, Rotterdam, Zoetermeer, Capelle -> @h2notify    
Eindhoven, Helmond, Den Bosch, Tilberg -> @h2snotify_eindhoven    
Arnhem, Nijmegen  -> @h2snotify_arnhem   

## Usage:
`cloudscraper` is used because Holland2Stay's GraphQL endpoint is now protected by Cloudflare and plain `requests` gets HTTP 403.

To run once:
```bash
cd h2snotifier
./run.sh
```

To install a cron job with a small random delay before each run:
```bash
cd h2snotifier
./install_cron.sh
```

The default schedule is every 10 minutes and each run sleeps for a random 0-180 seconds first to avoid a perfectly fixed request pattern.

You can change the schedule or jitter:
```bash
cd h2snotifier
JITTER_MAX_SECONDS=300 ./install_cron.sh "*/15 * * * *"
```

To stop the cron job and stop any currently running notifier process:
```bash
cd h2snotifier
./stop.sh
```


## Contributors
[MHMALEK](https://github.com/MHMALEK)
