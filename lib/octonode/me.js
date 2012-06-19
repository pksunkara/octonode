(function() {
  var Me, Org, User;

  User = require('./user');

  Org = require('./org');

  Me = (function() {

    function Me(client) {
      this.client = client;
    }

    Me.prototype.profile = function(data) {
      var _this = this;
      return Object.keys(data).forEach(function(e) {
        return _this[e] = data[e];
      });
    };

    Me.prototype.info = function(cb) {
      return this.client.get('/user', function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User info error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.update = function(info, cb) {
      return this.client.post('/user', info, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User update error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.emails = function(cbOrEmails, cb) {
      if ((cb != null) && typeof cbOrEmails !== 'function') {
        return this.setEmails(cbOrEmails, cb);
      } else if (!(cb != null) && typeof cbOrEmails !== 'function') {
        return this.deleteEmails(cbOrEmails);
      } else {
        return this.client.get('/user/emails', function(err, s, b) {
          if (err) return cb(err);
          if (s !== 200) {
            return cb(new Error('User emails error'));
          } else {
            return cb(null, b);
          }
        });
      }
    };

    Me.prototype.setEmails = function(emails, cb) {
      return this.client.post('/user/emails', emails, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 201) {
          return cb(new Error('User setEmails error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.deleteEmails = function(emails) {
      var _this = this;
      return this.client.del('/user/emails', emails, function(err, s, b) {
        if ((err != null) || s !== 204) return _this.deleteEmails(emails);
      });
    };

    Me.prototype.followers = function(cb) {
      return this.client.get('/user/followers', function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User followers error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.following = function(cbOrUser, cb) {
      if ((cb != null) && typeof cbOrUser !== 'function') {
        return this.checkFollowing(cbOrUser, cb);
      } else {
        return this.client.get('/user/following', function(err, s, b) {
          if (err) return cb(err);
          if (s !== 200) {
            return cb(new Error('User following error'));
          } else {
            return cb(null, b);
          }
        });
      }
    };

    Me.prototype.checkFollowing = function(user, cb) {
      return this.client.get("/user/following/" + user, function(err, s, b) {
        if (err) return cb(err);
        return cb(null, s === 204);
      });
    };

    Me.prototype.follow = function(user) {
      var _this = this;
      return this.client.put("/user/following/" + user, {}, function(err, s, b) {
        if ((err != null) || s !== 204) return _this.follow(user);
      });
    };

    Me.prototype.unfollow = function(user) {
      var _this = this;
      return this.client.del("/user/following/" + user, {}, function(err, s, b) {
        if ((err != null) || s !== 204) return _this.unfollow(user);
      });
    };

    Me.prototype.keys = function(cbOrIdOrKey, cbOrKey, cb) {
      if (!(cb != null) && typeof cbOrIdOrKey === 'number' && typeof cbOrKey === 'function') {
        return this.getKey(cbOrIdOrKey, cbOrKey);
      } else if (!(cbOrKey != null) && !(cb != null) && typeof cbOrIdOrKey === 'number') {
        return this.deleteKey(cbOrIdOrKey);
      } else if (!(cb != null) && typeof cbOrKey === 'function' && typeof cbOrIdOrKey === 'object') {
        return this.createKey(cbOrIdOrKey, cbOrKey);
      } else if (typeof cb === 'function' && typeof cbOrIdOrKey === 'number' && typeof cbOrKey('object')) {
        return this.updateKey(cbOrIdOrKey, cbOrKey, cb);
      } else {
        return this.client.get('/user/keys', function(err, s, b) {
          if (err) return cb(err);
          if (s !== 200) {
            return cb(new Error('User keys error'));
          } else {
            return cb(null, b);
          }
        });
      }
    };

    Me.prototype.getKey = function(id, cb) {
      return this.client.get("/user/keys/" + id, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User getKey error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.createKey = function(key, cb) {
      return this.client.post('/user/keys', key, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 201) {
          return cb(new Error('User createKey error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.updateKey = function(id, key, cb) {
      return this.client.post("/user/keys/" + id, key, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('User updateKey error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.deleteKey = function(id) {
      var _this = this;
      return this.client.del("/user/keys/" + id, {}, function(err, s, b) {
        if ((err != null) || s !== 204) return _this.deleteKey(id);
      });
    };

    Me.prototype.org = function(name) {
      return new Org(name, this.client);
    };

    Me.prototype.repos = function(cbOrRepo, cb) {
      if (typeof cb === 'function' && typeof cbOrRepo === 'object') {
        return this.createRepo(cbOrRepo, cb);
      } else {
        return this.client.get("/user/repos", function(err, s, b) {
          if (err) return cb(err);
          if (s !== 200) {
            return cb(new Error('User repos error'));
          } else {
            return cb(null, b);
          }
        });
      }
    };

    Me.prototype.createRepo = function(repo, cb) {
      return this.client.post("/user/repos", repo, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 201) {
          return cb(new Error('User createRepo error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Me.prototype.fork = function(repo, cb) {
      return this.client.post("/repos/" + repo + "/forks", {}, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 202) {
          return cb(new Error('User fork error'));
        } else {
          return cb(null, b);
        }
      });
    };

    return Me;

  })();

  module.exports = Me;

}).call(this);
