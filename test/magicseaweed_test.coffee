Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'
moment = require 'moment-timezone'
expect = chai.expect
helper = new Helper '../src/magicseaweed.coffee'
mockResp = require './fixtures/fixture.coffee'
defaultLocation = '123'
expectedResp = "```.-----------------------------------------------------------.\n|             Day              | Combined Swell |   Wind    |\n|------------------------------|----------------|-----------|\n| Wednesday, Sep 30th, 2:00 am | 7.5ft @ 10s SE | 13mph SSE |\n'-----------------------------------------------------------'```"

describe 'seaweed', ->
  beforeEach ->
    process.env.HUBOT_MAGICSEAWEED_API_KEY = defaultLocation
    process.env.HUBOT_MAGICSEAWEED_DEFAULT_LOCATION = '392'
    moment.tz.setDefault('America/New_York')
    @room = helper.createRoom()
    do nock.disableNetConnect

  afterEach ->
    @room.destroy()
    nock.cleanAll()
    moment.tz.setDefault()

  context 'user asks hubot for the surf forecast without passing a location', ->
    context 'the Magicseaweed API responds successfully using the default location', ->
      beforeEach (done) ->
        nock('http://magicseaweed.com')
          .get('/api/123/forecast/?spot_id=392')
          .reply(200, mockResp)

        @room.user.say 'alice', '@hubot seaweed'

        # wait for hubot to respond
        setTimeout done, 100

      it 'reports the Magicseaweed forecast', ->
        expect(@room.messages).to.eql [
          ['alice', '@hubot seaweed']
          ['hubot', expectedResp]
        ]

    context 'there is no default location', ->
      beforeEach () ->
        process.env.HUBOT_MAGICSEAWEED_DEFAULT_LOCATION = ''
        @room.user.say 'alice', '@hubot seaweed'

      afterEach () ->
        process.env.HUBOT_MAGICSEAWEED_DEFAULT_LOCATION = defaultLocation

      it 'reports a helpful message', ->
        expect(@room.messages).to.eql [
          ['alice', '@hubot seaweed']
          ['hubot', 'No location ID passed and no `HUBOT_MAGICSEAWEED_DEFAULT_LOCATION` environment variable set']
        ]

    context 'the Magicseaweed API does not respond 200', ->
      beforeEach (done) ->
        nock('http://magicseaweed.com')
          .get('/api/123/forecast/?spot_id=392')
          .reply(500)

        @room.user.say 'alice', '@hubot seaweed'

        # wait for hubot to respond
        setTimeout done, 100

      it 'reports a problem making a request to the API', ->
        expect(@room.messages).to.eql [
          ['alice', '@hubot seaweed']
          ['hubot', 'Magicseaweed request responded HTTP 500 :(']
        ]

  context 'user asks hubot for the surf forecast with a non-default location', ->
    beforeEach (done) ->
      nock('http://magicseaweed.com')
        .get('/api/123/forecast/?spot_id=555')
        .reply(200, mockResp)

      @room.user.say 'alice', '@hubot seaweed 555'

      # wait for hubot to respond
      setTimeout done, 100

    it 'reports the Magicseaweed forecast for the location it is passed', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot seaweed 555']
        ['hubot', expectedResp]
      ]

  context 'user asks hubot for seaweed usage help', ->
    beforeEach () ->
      @room.user.say 'alice', '@hubot seaweed help'

    it 'reports a usage explanation', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot seaweed help']
        ['hubot', 'hubot seaweed <location-id> - return the Magicseaweed forecast for the `<location-id>` passed. If no `<location-id>` is passed, use `HUBOT_MAGICSEAWEED_DEFAULT_LOCATION`']
      ]
