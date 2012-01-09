
assert = require('assert')
should = require('should')
helper = require('./support/helper')
octonode = require('../lib/octonode')
#nock = require('./support/nock')
nock = require('nock')

describe 'WHEN testing repository.info', ->
  before (done) ->
    @timeout(10000)
    test = nock("https://api.github.com").get('/repos/pksunkara/octonode').reply(200, JSON.stringify({"has_issues":true,"forks":5,"has_downloads":true,"svn_url":"https://github.com/pksunkara/octonode"}))
    
    helper.start null, done
  after ( done) ->
    helper.stop done

  it 'should exist and have all the right values', ( done) ->
    @timeout(10000)
    #nock.viewGet("/repos/pksunkara/octonode",200, {"has_issues":true,"forks":5,"has_downloads":true,"svn_url":"https://github.com/pksunkara/octonode"})
    
    
    client = octonode.client()
    rep = client.repository('pksunkara/octonode')
     
    should.exist rep
    rep.should.have.property('name',"pksunkara/octonode")
    rep.should.have.property('client')
    
    rep.info (err,data) ->
      should.not.exist err
      return done(err) if err
      
      should.exist data
      console.log "DATA #{JSON.stringify(data)} ENDDATA"
      done()
      
