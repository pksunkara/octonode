#
# organization.coffee: Github organization class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Organization

  constructor: (@name, @client) ->

  # Get an organization
  # '/orgs/flatiron' GET
  info: (cb) ->
    @client.get "/orgs/#{@name}", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Organization info error')) else cb null, b

  # Get an organization's teams.
  # '/orgs/flatiron/teams' GET
  getTeam: (cb) ->
    @client.get "/orgs/#{@name}/teams", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Organization teams error')) else cb null, b


  # Get an organization's members.
  # '/orgs/flatiron/members' GET
  getMembers: (cb) ->
    @client.get "/orgs/#{@name}/members", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Organization members error')) else cb null, b
 
  # Get a team's members.
  # '/team/owners/members' GET
  getTeamMembers: (team, cb) ->
    @client.get "/teams/#{@team}/members", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Team members error')) else cb null, b  	

# Export module
module.exports = Organization
