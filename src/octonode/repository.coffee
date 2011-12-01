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
  # `/repos/pkumar/hub`
  info: (cb) ->
    @client.get "/repos/#{@name}", (s, b) ->
      if s is 404 then throw new Error 'Repository not found' else cb b
