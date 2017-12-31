Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

process.env.HUBOT_MAGIC_SEAWEED_API_KEY = '123'
process.env.HUBOT_MAGIC_SEAWEED_DEFAULT_LOCATION = '392'

helper = new Helper '../src/magicseaweed.coffee'
mockResp = require './fixtures/fixture.coffee'

describe 'seaweed', ->
  beforeEach ->
    @room = helper.createRoom()
    do nock.disableNetConnect


  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user asks hubot for the surf forecast', ->
    context 'the Magic Seaweed API responds successfully', ->
      beforeEach (done) ->
        nock('http://magicseaweed.com')
          .get('/api/123/forecast/?spot_id=392')
          .reply(200, mockResp)

        @room.user.say 'alice', '@hubot seaweed'

        # wait for hubot to respond
        setTimeout done, 100

      it 'fetches the MagicSeaweed forecast', ->
        expect(@room.messages).to.eql [
          ['alice', '@hubot seaweed']
          ['hubot', mockResp]
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
