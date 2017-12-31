# hubot-magicseaweed

A [Hubot](https://hubot.github.com) script to grab the [Magicseaweed](http://magicseaweed.com) surf forecast information.

[![Build Status](https://travis-ci.org/mdb/hubot-magicseaweed.png)](https://travis-ci.org/mdb/hubot-magicseaweed)

## Installation

Run `npm install --save hubot-magicseaweed`

Add **hubot-magicseaweed** to your `external-scripts.json`:

```json
["hubot-magicseaweed"]
```

## Configuration
- `HUBOT_MAGICSEAWEED_API_KEY` an API key from [magicseaweed.com](https://magicseaweed.com)
- `HUBOT_MAGICSEAWEED_DEFAULT_LOCATION` if unset, `seaweed` commands without a location will be ignored

## Sample Interaction
```
user> hubot: seaweed 392
```

## Development

Install dependencies:

```
npm install
```

Run tests:

```
npm test
```
