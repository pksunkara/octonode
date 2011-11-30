/*
 * Github authentication in cli
 */
var github = require('../lib/octonode');

/*
 * Login to github using username and password
 */
github.auth.config({
  username: 'pkumar',
  password: 'password'
}).login(['user', 'repo', 'gist'], function (token) {
  console.log(token);
});
