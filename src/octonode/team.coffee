#
# team.coffee: Github organization team class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Team

  constructor: (@id, @client) ->

  # Get a team
  # '/teams/37' GET
  info: (cb) ->
    @client.get "/teams/#{@id}", (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Team info error')) else cb null, b, h

  # Get a teams's members
  # '/teams/37/members' GET
  members: (cb) ->
    @client.get "/teams/#{@id}/members", (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Team members error')) else cb null, b, h

  # Check a team's member
  # '/teams/37/members/pksunkara' GET
  member: (user, cb) ->
    @client.get "/teams/#{@id}/members/#{user}", (err, s, b, h)  ->
      return cb(err) if err
      cb null, s is 204, h
  
    # Add a user to a team (must have admin permissions to do so)
  # '/teams/37/members/pksunkara' PUT
  newUser: (user, cb) ->
    @client.put "/teams/{@id}/members/#{user}", (err, s, b, h) ->
      return cb(err) if err
      cb null, s is 204, h
  
  # Remove a user from a team (must have admin permissions to do so)
  # '/teams/37/members/pksunkara' DELETE
  rmUser: (user, cb) ->
    @client.del "/teams/#{@id}/members/#{user}", (err, s, b, h) ->
      return cb(err) if err
      cb null, s is 204, h
  
  # List repos of a team
  # '/teams/37/repos/' GET
  repos: (cb) ->
    @client.get "/teams/#{@id}/repos/", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Team repos error")) else cb null, b, h


# Export module
module.exports = Team
