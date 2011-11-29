/*
 * Github authentication in cli
 */
var github = require('../lib/octonode');

var token = github.auth.load({
  username: 'pkumar',
  password: 'password'
}).login(['user', 'repo', 'gist']);
