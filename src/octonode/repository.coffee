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


# Export module
module.exports = Repository
