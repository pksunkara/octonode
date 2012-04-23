# CHANGELOG

## 0.2.0

* The api call to get a repository instance has been changed to `octonode.repo('repo/name')` from `octonode.repository('repo/name')`
* The api call to get an organization instance has been changed to `octonode.org('flatiron')` from `octonode.organization('flatiron')`
* The api call to create a new client do not need `new` from now onwards
* Keys passed to authorization config while working in web mode have been changed to `id` and `secret` from `client_id` and `client_secret` respectively
