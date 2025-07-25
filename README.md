# MilanoBot

A small application to scrap the lunch menu from https://www.pizzeria-milano.eu/ and send it out to a signal group. Requires a signal API server.

## Get started

Start with docker `docker run -d --rm -e SIGNAL_API_URL=$SIGNAL_API_URL -e SIGNAL_SENDER=$SIGNAL_SENDER -e SIGNAL_GROUP_ID=$SIGNAL_GROUP_ID emischorr/milano_bot:latest start`
or docker compose:
```yaml
services:
  milano_bot:
    image: emischorr/milano_bot:latest
    environment:
      - SIGNAL_API_URL=${SIGNAL_API_URL}
      - SIGNAL_SENDER=${SIGNAL_SENDER}
      - SIGNAL_GROUP_ID=${SIGNAL_GROUP_ID}
    restart: unless-stopped
```

Service starts scraping the menu every 2h. Only on changes a message gets send out to the configured signal group.