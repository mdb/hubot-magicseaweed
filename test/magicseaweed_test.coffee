Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

process.env.HUBOT_MAGIC_SEAWEED_API_KEY = '123'
process.env.HUBOT_MAGIC_SEAWEED_DEFAULT_LOCATION = '392'

helper = new Helper '../src/magicseaweed.coffee'
mockResp = require './fixtures/fixture.coffee'
expectedResp =  "```.---------------------------------------------------------.\n|            Day             | Combined Swell |   Wind    |\n|----------------------------|----------------|-----------|\n| Tuesday, Sep 29th, 8:00 pm | 7.5ft @ 10s SE | 13mph SSE |\n'---------------------------------------------------------'```"

describe 'seaweed', ->
  beforeEach ->
    @room = helper.createRoom()
    do nock.disableNetConnect

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user asks hubot for the surf forecast without passing a location', ->
    context 'the Magic Seaweed API responds successfully using the default location', ->
      beforeEach (done) ->
        nock('http://magicseaweed.com')
          .get('/api/123/forecast/?spot_id=392')
          .reply(200, mockResp)

        @room.user.say 'alice', '@hubot seaweed'

        # wait for hubot to respond
        setTimeout done, 100

      it 'reports the Magic Seaweed forecast', ->
        expect(@room.messages).to.eql [
          ['alice', '@hubot seaweed']
          ['hubot', expectedResp]
        ]

    context 'the Magic Seaweed API does not respond 200', ->
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
          ['hubot', 'Magic Seaweed request responded HTTP 500 :(']
        ]

  context 'user asks hubot for the surf forecast with a non-default location', ->
    beforeEach (done) ->
      nock('http://magicseaweed.com')
        .get('/api/123/forecast/?spot_id=555')
        .reply(200, mockResp)

      @room.user.say 'alice', '@hubot seaweed 555'

      # wait for hubot to respond
      setTimeout done, 100

    it 'reports the Magic Seaweed forecast for the location it is passed', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot seaweed 555']
        ['hubot', expectedResp]
      ]
