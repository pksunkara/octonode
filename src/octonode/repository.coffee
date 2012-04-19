#
# repository.coffee: Github repository class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Repository

  constructor: (@name, @client) ->

  _invokeGet: (path,expectedStatus = 200,methodName,cb) ->
    @client.get path, (err, s, b)  ->
      return cb(err) if err
      if s isnt expectedStatus then cb(new Error("Repository.#{methodName} error")) else cb null, b

  _invokePost: (path,body,expectedStatus = 202,methodName,cb) ->
    @client.post path, body, (err, s, b)  ->
      return cb(err) if err
      if s isnt expectedStatus then cb(new Error("Repository.#{methodName} error")) else cb null, b

  # Get a repository
  # '/repos/pkumar/hub' GET
  info: (cb) ->
    @client.get "/repos/#{@name}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository info error")) else cb null, b

  # Get the commits for a repository
  # '/repos/pkumar/hub/commits' GET
  commits: (cb) ->
    @client.get "/repos/#{@name}/commits", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository commits error")) else cb null, b

  # Get the tags for a repository
  # '/repos/pkumar/hub/tags' GET
  tags: (cb) ->
    @client.get "/repos/#{@name}/tags", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository tags error")) else cb null, b

  # Get the languages for a repository
  # '/repos/pkumar/hub/languages' GET
  languages: (cb) ->
    @client.get "/repos/#{@name}/languages", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository languages error")) else cb null, b

  # Get the contributors for a repository
  # '/repos/pkumar/hub/contributors' GET
  contributors: (cb) ->
    @client.get "/repos/#{@name}/contributors", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository contributors error")) else cb null, b

  # Get the teams for a repository
  # '/repos/pkumar/hub/teams' GET
  teams: (cb) ->
    @client.get "/repos/#{@name}/teams", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository teams error")) else cb null, b

  # Get the branches for a repository
  # '/repos/pkumar/hub/branches' GET
  branches: (cb) ->
    @client.get "/repos/#{@name}/branches", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository branches error")) else cb null, b

  # Get the issues for a repository
  # '/repos/pkumar/hub/issues' GET
  issues: (cb) ->
    @client.get "/repos/#{@name}/issues", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository issues error")) else cb null, b

  # Get the forks for a repository
  # '/repos/pkumar/hub/forks' GET
  forks: (cb) ->
    @client.get "/repos/#{@name}/forks", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repository forks error")) else cb null, b

# Export module
module.exports = Repository
