(function() {
  var User;

  User = (function() {

    function User(login, client) {
      this.login = login;
      this.client = client;
    }

    User.prototype.profile = function(data) {
      var _this = this;
      return Object.keys(data).forEach(function(e) {
        return _this[e] = data[e];
      });
    };

    User.prototype.info = function(cb) {
      return this.client.get("/users/" + this.login, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User info error'));
        } else {
          return cb(null, b);
        }
      });
    };

    User.prototype.followers = function(cb) {
      return this.client.get("/users/" + this.login + "/followers", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User followers error'));
        } else {
          return cb(null, b);
        }
      });
    };

    User.prototype.following = function(cb) {
      return this.client.get("/users/" + this.login + "/following", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User following error'));
        } else {
          return cb(null, b);
        }
      });
    };

    return User;

  })();

  module.exports = User;

}).call(this);
