/*
 * Get info about a public user
 */
var github = require('../lib/octonode');

/*
 * Build a client without any token or authentication
 */
var client = new github.client('someaccesstoken');

client.get('/user', function (s, b) {
  console.log(b);
});
