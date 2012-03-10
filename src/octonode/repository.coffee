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
    @_invokeGet "/repos/#{@name}",200,"info",cb

  # Get the commits for a repository
  # '/repos/pkumar/hub/commits' GET
  getCommits: (cb) -> 
    @_invokeGet "/repos/#{@name}/commits",200,"getCommits",cb

  # Get the tags for a repository
  # '/repos/pkumar/hub/commits' GET
  getTags: (cb) -> 
    @_invokeGet "/repos/#{@name}/tags",200,"getTags",cb

  # Get the languages for a repository
  # '/repos/pkumar/hub/languages' GET
  getLanguages: (cb) ->
    @_invokeGet "/repos/#{@name}/languages",200,"getLanguages",cb

  # Get the contributors for a repository
  # '/repos/pkumar/hub/contributors' GET
  getContributors: (cb) ->
    @_invokeGet "/repos/#{@name}/contributors",200,"getContributors",cb

  # Get the teams for a repository
  # '/repos/pkumar/hub/teams' GET
  getTeams: (cb) ->
    @_invokeGet "/repos/#{@name}/teams",200,"getTeams",cb

  # Get the branches for a repository
  # '/repos/pkumar/hub/branches' GET
  getBranches: (cb) ->
    @_invokeGet "/repos/#{@name}/branches",200,"getBranches",cb

  # Get the issues for a repository
  # '/repos/pkumar/hub/issues' GET
  getIssues: (cb) ->
    @_invokeGet "/repos/#{@name}/issues",200,"getIssues",cb

  # Get the forks for a repository
  # '/repos/pkumar/hub/forks' GET
  getForks: (cb) ->
    @_invokeGet "/repos/#{@name}/forks",200,"getForks",cb

  # Create a fork for a repository
  # '/repos/pkumar/hub/forks' POST
  createFork: (cb) ->
    @_invokePost "/repos/#{@name}/forks",{},202,"createFork",cb

# Export module
module.exports = Repository
