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

  # Get an organization's member.
  # '/orgs/flatiron/members/marak' GET
  member: (user, cb) ->
    @client.get "/orgs/#{@name}/members/#{user}", (err, s, b)  ->
      return cb(err) if err
      cb null, s is 204

# Export module
module.exports = Org
