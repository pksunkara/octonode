#
# org.coffee: Github organization class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Org

  constructor: (@name, @client) ->

  # Get an organization
  # '/orgs/flatiron' GET
  info: (cb) ->
    @client.get "/orgs/#{@name}", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org info error')) else cb null, b

  # Edit an organization
  # '/orgs/flatiron' POST
  update: (info, cb) ->
    @client.post "/orgs/#{@name}", info, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org update error')) else cb null, b

  # List organization repositories
  # '/orgs/flatiron/repos' GET
  repos: (cbOrRepo, cb) ->
    if typeof cb is 'function' and typeof cbOrRepo is 'object'
      @createRepo cbOrRepo, cb
    else
      cb = cbOrRepo
      @client.get "/orgs/#{@name}/repos", (err, s, b) ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('Org repos error')) else cb null, b

  # Create an organisation repository
  # '/orgs/flatiron/repos' POST
  createRepo: (repo, cb) ->
    @client.post "/orgs/#{@name}/repos", repo, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Org createRepo error')) else cb null, b

  # Get an organization's teams.
  # '/orgs/flatiron/teams' GET
  teams: (cb) ->
    @client.get "/orgs/#{@name}/teams", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org teams error')) else cb null, b

  # Get an organization's members.
  # '/orgs/flatiron/members' GET
  members: (cb) ->
    @client.get "/orgs/#{@name}/members", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org members error')) else cb null, b

  # Check an organization's member.
  # '/orgs/flatiron/members/pksunkara' GET
  member: (user, cb) ->
    @client.getNoFollow "/orgs/#{@name}/members/#{user}", (err, s, b)  ->
      return cb(err) if err
      cb null, s is 204 or s is 302

# Export module
module.exports = Org
