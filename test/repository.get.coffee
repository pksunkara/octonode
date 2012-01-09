
assert = require('assert')
should = require('should')
helper = require('./support/helper')
octonode = require('../lib/octonode')
_ = require('underscore')
#nock = require('./support/nock')
nock = require('nock')

sampleBody = {"has_issues":true,"forks":5,"has_downloads":true,"svn_url":"https://github.com/pksunkara/octonode"}

noParameterGet = 
  info:
    url: "/repos/pksunkara/octonode"
  getCommits:
    url: "/repos/pksunkara/octonode/commits"
  getTags:
    url: "/repos/pksunkara/octonode/tags"
    
  

describe 'WHEN testing repository get methods', ->
  beforeEach (done) ->
    @timeout(10000)    
    
    nocker = nock("https://api.github.com")
    for key in _.keys(noParameterGet)
      test = noParameterGet[key]
      nocker.get(test.url).reply(200, JSON.stringify(sampleBody))
      #console.log "Mocking request for test #{key} for url #{test.url}"
    
    helper.start null, done
  after ( done) ->
    helper.stop done

  for key in _.keys(noParameterGet)
    test = noParameterGet[key]
            
    it "should invoke #{key} and return with a result", ( done) ->
      @timeout(10000)
    
    
      client = new octonode.client()
      rep = client.repository('pksunkara/octonode')
      should.exist rep
      rep.should.have.property('name',"pksunkara/octonode")
      rep.should.have.property('client')
      should.exist rep[key]
      
      rep[key] (err,data) ->
        should.not.exist err
        return done(err) if err
      
        should.exist data
        #console.log "DATA #{JSON.stringify(data)} ENDDATA"
        done()
      
