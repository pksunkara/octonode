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
    @client.get "/teams/#{@id}", null, (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Team info error')) else cb null, b

  # Get a teams's members
  # '/teams/37/members' GET
  members: (cb) ->
    @client.get "/teams/#{@id}/members", null, (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Team members error')) else cb null, b

  # Check a team's member
  # '/teams/37/members/pksunkara' GET
  member: (user, cb) ->
    @client.get "/teams/#{@id}/members/#{user}", null, (err, s, b)  ->
      return cb(err) if err
      cb null, s is 204

# Export module
module.exports = Team
