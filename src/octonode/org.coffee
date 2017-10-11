#
# org.coffee: Github organization class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Org extends Base

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
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  teams: (params..., cb) ->
    @client.get "/orgs/#{@name}/teams", params..., (err, s, b, h)  ->
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

  # Check membership for a user in the org.
  # '/orgs/flatiron/memberships/pksunkara' GET
  membership: (user, cb) ->
    @client.getOptions "/orgs/#{@name}/memberships/#{user}", { headers: { Accept: 'application/vnd.github.moondragon+json'} },(err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Org memberships error')) else cb null, b, h

  # Check an organization's member.
  # '/orgs/flatiron/members/pksunkara' GET
  member: (user, cb) ->
    @client.getNoFollow "/orgs/#{@name}/members/#{user}", (err, s, b, h)  ->
      return cb(err) if err
      cb null, s is 204, h

  # Check an organization's public member.
  # '/orgs/flatiron/public_members/pksunkara' GET
  publicMember: (user, cb) ->
    @client.getNoFollow "/orgs/#{@name}/public_members/#{user}", (err, s, b, h)  ->
      return cb(err) if err
      cb null, s is 204, h

  # Publicize the authenticated user's membership in an organization.
  # '/orgs/flatiron/public_members/pksunkara' PUT
  publicizeMembership: (user, cb) ->
    @client.put "/orgs/#{@name}/public_members/#{user}", null, (err, s, b, h) ->
      return cb(err)  if err
      if s isnt 204 then cb new Error("Org publicizeMembership error") else cb null, b, h

  # Conceal public membership of the authenticated user in the organization.
  # '/orgs/flatiron/public_members/pksunkara' DELETE
  concealMembership: (user, cb) ->
    @client.del "/orgs/#{@name}/public_members/#{user}", null, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Org concealMembership error")) else cb null, b, h

  # Add a user to an organization
  # '/orgs/flatiron/members/pksunkara' PUT
  addMember: (user, options, cb) ->
    @client.put "/orgs/#{@name}/memberships/#{user}", options, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Org addMember error")) else cb null, b, h

  # Remove a user from an organization and all of its teams
  # '/orgs/flatiron/members/pksunkara' DELETE
  removeMember: (user, cb) ->
    @client.del "/orgs/#{@name}/members/#{user}", null, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Org removeMember error")) else cb null, b, h

  # Create an organisation team
  # '/orgs/flatiron/teams' POST
  createTeam: (options, cb) ->
    @client.post "/orgs/#{@name}/teams", options, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Org createTeam error')) else cb null, b, h

  # Add an organisation team repository
  # '/teams/37/repos/flatiron/hub' PUT
  addTeamRepo: (team, repo, cbOrOptions, cb) ->
    if !cb? and cbOrOptions
      cb = cbOrOptions
      param = {}
      options =
        'Content-Type': 'application/json'
    else if typeof cbOrOptions is 'object'
      param = cbOrOptions
      options =
        'Content-Type': 'application/json'
        'Accept': 'application/vnd.github.ironman-preview+json'
    @client.put "/teams/#{team}/repos/#{@name}/#{repo}", param, options, (err, s, b, h) ->
      return cb(err)  if err
      if s isnt 204 then cb(new Error('Org addTeamRepo error')) else cb null, b, h

  # List hooks
  # '/orgs/flatiron/hub/hooks' GET
  hooks: (params..., cb) ->
    @client.get "/orgs/#{@name}/hooks", params..., (err, s, b, h) ->
      return cb(err) if (err)
      if s isnt 200 then cb(new Error("Org hooks error")) else cb null, b, h

  # Create a hook
  # '/orgs/flatiron/hub/hooks' POST
  hook: (hook, cb) ->
    @client.post "/orgs/#{@name}/hooks", hook, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Org createHook error")) else cb null, b, h

  # Delete a hook
  # '/orgs/flatiron/hub/hooks/37' DELETE
  deleteHook: (id, cb) ->
    @client.del "/orgs/#{@name}/hooks/#{id}", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Org deleteHook error")) else cb null, b, h

# Export module
module.exports = Org
