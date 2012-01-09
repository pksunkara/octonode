
assert = require('assert')
should = require('should')
helper = require('./support/helper')
Repository = require('../lib/octonode/repository')

describe 'WHEN testing repository', ->
  before (done) ->
    @timeout(10000)
    helper.start null, done
  after ( done) ->
    helper.stop done

  it 'should exist and have all the right values', ( done) ->
    mockClient = {}
    rep = new Repository("repname",mockClient)
    
    should.exist rep
    rep.should.have.property('name',"repname")
    rep.should.have.property('client',mockClient)
      
    done()
      
