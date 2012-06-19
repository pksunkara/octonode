(function() {
  var octonode;

  octonode = module.exports = {
    auth: require('./octonode/auth'),
    client: require('./octonode/client'),
    user: require('./octonode/user'),
    repo: require('./octonode/repo'),
    org: require('./octonode/org'),
    team: require('./octonode/team'),
    gist: require('./octonode/gist'),
    me: require('./octonode/me')
  };

}).call(this);
