#
# repository.coffee: Github repository class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Repository

  constructor: (@name, @client) ->

  # Get a repository
  # '/repos/pkumar/hub' GET
  info: (cb) ->
    @client.get "/repos/#{@name}", (s, b) ->
      if s isnt 200 then throw new Error 'Repository info error' else cb b

# Export module
module.exports = Repository