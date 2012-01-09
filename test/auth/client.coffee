should = require('should')
helper = require('./support/helper')
Client = require('../lib/octonode/client')
nock = require('nock')

describe 'WHEN working with client', ->
  before (done) ->
    @timeout(10000)
    test = nock("https://api.github.com")
    test.get('/repos/pksunkara/octonode').reply(200, JSON.stringify({"i_am_json":true}))
    test.post('/repos/pksunkara/octonode',{}).reply(201, JSON.stringify({"i_am_json":true}))
    test.put('/repos/pksunkara/octonode',{}).reply(200, JSON.stringify({"i_am_json":true}))
    test.delete('/repos/pksunkara/octonode',{}).reply(204,null)
    
    helper.start null, done
  after ( done) ->
    helper.stop done

  describe 'WHEN instantiating a client with token', ->
    it 'should exist and have the token set',  ->
      client = new Client("some_token")
    
      should.exist client
      client.should.have.property('token',"some_token")

    describe 'WHEN creating a query (client.query)', ->
      it 'should include the token in the query string', ->
        client = new Client("some_token")
        url = client.query('/repos')
      
        should.exist url
        url.should.equal('https://api.github.com/repos?access_token=some_token')


  describe 'WHEN instantiating a client without a token', ->
    it 'should exist and have no token set',  ->
      client = new Client()

      should.exist client
      client.should.not.have.property('token')
      
    describe 'WHEN creating a query (client.query)', ->
      it 'should include no token in the query string', ->
        client = new Client()
        url = client.query('/repos')

        should.exist url
        url.should.equal('https://api.github.com/repos')

      it 'should resolve an empty path to .../', ->
        client = new Client()
        url = client.query()

        should.exist url
        url.should.equal('https://api.github.com/')
      
  describe 'WHEN accessing a sub resource', ->
    it 'should return a valid me',  ->
       client = new Client()
       me = client.me()
       should.exist me
       me.should.have.property('client',client)

    it 'should return a valid user',  ->
      client = new Client()
      user = client.user('frank')
      should.exist user
      user.should.have.property('client',client)
      user.should.have.property('login','frank')

    it 'should return a valid organization',  ->
      client = new Client()
      organization = client.organization('orga')
      should.exist organization
      organization.should.have.property('client',client)
      organization.should.have.property('name','orga')

    it 'should return a valid repository',  ->
      client = new Client()
      repository = client.repository('repo')
      should.exist repository
      repository.should.have.property('client',client)
      repository.should.have.property('name','repo')

    # TODO: Handle different cases, with profile
    
  describe 'WHEN using GET', ->
    it 'should return a parsed body',  (done)->
      client = new Client()
      client.get '/repos/pksunkara/octonode', (err,status,body) ->
        should.not.exist err
        return done(err) if err
        should.exist.status
        should.exist body
        status.should.equal 200
        body.should.have.property('i_am_json',true)
        done()

  describe 'WHEN using POST', ->
    it 'should return a parsed body',  (done)->
      client = new Client()
      client.post '/repos/pksunkara/octonode',{}, (err,status,body) ->
        should.not.exist err
        return done(err) if err
        should.exist.status
        should.exist body
        status.should.equal 201
        body.should.have.property('i_am_json',true)
        done()

  describe 'WHEN using PUT', ->
    it 'should return without error',  (done)->
      client = new Client()
      client.put '/repos/pksunkara/octonode', {}, (err,status,body) ->
        should.not.exist err
        return done(err) if err
        should.exist.status
        should.exist body
        status.should.equal 200
        body.should.have.property('i_am_json',true)
        done()
    
  describe 'WHEN using DEL', ->
    it 'should return a parsed body',  (done)->
      client = new Client()
      client.del '/repos/pksunkara/octonode', {},(err,status,body) ->
        should.not.exist err
        return done(err) if err
        should.exist.status
        status.should.equal 204
        done()

