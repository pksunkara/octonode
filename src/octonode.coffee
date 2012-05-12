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

  # [Repo](octonode/repo.html) class for github
  repo: require './octonode/repo'

  # [Org](octonode/org.html) class for github
  org: require './octonode/org'

  # [Team](octonode/team.html) class for github
  team: require './octonode/team'

  # [Authenticated user](octonode/me.html) class for github
  me: require './octonode/me'
