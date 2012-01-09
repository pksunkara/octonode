#
# octonode.coffee: Top level include for octonode module
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

octonode = module.exports =

  # [Authentication](octonode/auth.html) for github
  Auth: require './octonode/auth'

  # [Client](octonode/client.html) for github
  Client: require './octonode/client'

  # [User](octonode/user.html) class for github
  User: require './octonode/user'

  # [Repository](octonode/repository.html) class for github
  Repository: require './octonode/repository'

  # [Organization](octonode/organization.html) class for github
  Organization: require './octonode/organization'

  # [Authenticated user](octonode/me.html) class for github
  Me: require './octonode/me'

  client: (access_token = null) ->
    new octonode.Client(access_token)