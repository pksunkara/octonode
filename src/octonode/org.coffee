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
    @client.get "/orgs/#{@name}", (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org info error')) else cb null, b, h

  # Edit an organization
  # '/orgs/flatiron' POST
  update: (info, cb) ->
    @client.post "/orgs/#{@name}", info, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org update error')) else cb null, b, h

  # Get repository instance for client
  repo: (nameOrRepo, cb) ->
    if typeof cb is 'function' and typeof nameOrRepo is 'object'
      @createRepo nameOrRepo, cb
    else
      @client.repo "#{@name}/#{nameOrRepo}"

  # List organization repositories
  # '/orgs/flatiron/repos' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  repos: (params..., cb) ->
    @client.get "/orgs/#{@name}/repos", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org repos error')) else cb null, b, h

  # Create an organisation repository
  # '/orgs/flatiron/repos' POST
  createRepo: (repo, cb) ->
    @client.post "/orgs/#{@name}/repos", repo, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Org createRepo error')) else cb null, b, h

  # Get an organization's teams.
  # '/orgs/flatiron/teams' GET
  teams: (cb) ->
    @client.get "/orgs/#{@name}/teams", (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org teams error')) else cb null, b, h

  # Get an organization's members.
  # '/orgs/flatiron/members' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  members: (params..., cb) ->
    @client.get "/orgs/#{@name}/members", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org members error')) else cb null, b, h

  # Check an organization's member.
  # '/orgs/flatiron/members/pksunkara' GET
  member: (user, cb) ->
    @client.getNoFollow "/orgs/#{@name}/members/#{user}", (err, s, b, h)  ->
      return cb(err) if err
      cb null, s is 204, h

  # Create an organisation team
  # '/orgs/flatiron/teams' POST
  createTeam: (options, cb) ->
    @client.post "/orgs/#{@name}/teams", options, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Org createTeam error')) else cb null, b, h

  # Create an organisation team repository
  # '/teams/37/repos/flatiron/hub' PUT
  addTeamRepo: (team, repo, cb) ->
    @client.put "/teams/#{team}/repos/#{@name}/#{repo}", null, (err, s, b, h) ->
      return cb(err)  if err
      if s isnt 201 then cb new Error("Org addTeamRepo error") else cb null, b, h

# Export module
module.exports = Org
