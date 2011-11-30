#
# octonode.coffee: Top level include for octonode module
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

octonode = module.exports =

  # [Authentication](octonode/auth.html) for github
  auth: require './octonode/auth'

  # [Client](octonode/client.html) for github
  client: require './octonode/client'

  # [User](octonode/user.html) class for github
  user: require './octonode/user'

  # [Repository](octonode/repositoru.html) class for github
  repository: require './octonode/repository'

  # [Organization](octonode/organization.html) class for github
  organization: require './octonode/organization'
