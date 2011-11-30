/*
 * Github authentication in web
 */
var github = require('../lib/octonode');
var http = require('http');
var url = require('url');
var qs = require('querystring');

/*
 * Build the authorization config and url
 */
var auth_url = github.auth.config({
  client_id: 'mygithubclientid',
  client_secret: 'mygithubclientsecret'
}).login(['user', 'repo', 'gist']);

/*
 * Web server
 */
http.createServer(function (req, res) {

  uri = url.parse(req.url);

  // Redirect to github login
  if (uri.pathname=='/') {
    res.statusCode = 301;
    res.setHeader('Content-Type', 'text/plain');
    res.setHeader('Location', auth_url);
    res.end('Redirecting to ' + auth_url);
  }
  // Callback url from github login
  else if (uri.pathname=='/auth') {
    github.auth.login(qs.parse(uri.query).code, function (token) {
      console.log(token);
    });
    res.writeHead(200, {'Content-Type': 'text/plain'})
    res.end('');
  } else {
    res.writeHead(200, {'Content-Type': 'text/plain'})
    res.end('');
  }
}).listen(3000);

console.log('Server started on 3000')
