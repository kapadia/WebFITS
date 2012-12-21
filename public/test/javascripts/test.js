(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle) {
    for (var key in bundle) {
      if (has(bundle, key)) {
        modules[key] = bundle[key];
      }
    }
  }

  globals.require = require;
  globals.require.define = define;
  globals.require.brunch = true;
})();

window.require.define({"test/spec": function(exports, require, module) {
  

  
}});

window.require.define({"test/test-helpers": function(exports, require, module) {
  var expect;

  expect = require('expect.js');

  module.exports = {
    expect: expect
  };
  
}});

window.require.define({"test/views/app_view_test": function(exports, require, module) {
  var AppView;

  AppView = require('views/app_view');

  describe('AppView', function() {
    beforeEach(function() {
      return this.view = new AppView();
    });
    return it("should exist", function() {
      return expect(this.view).to.be.ok();
    });
  });
  
}});

window.require.define({"test/views/filter_test": function(exports, require, module) {
  var FilterView;

  FilterView = require('views/filter');

  describe('FilterView', function() {
    return beforeEach(function() {
      return this.view = new FilterView();
    });
  });
  
}});

window.require.define({"test/views/fits_test": function(exports, require, module) {
  var FitsView;

  FitsView = require('views/fits');

  describe('FitsView', function() {
    return beforeEach(function() {
      return this.view = new FitsView();
    });
  });
  
}});

window.require.define({"test/views/interface_test": function(exports, require, module) {
  var InterfaceView;

  InterfaceView = require('views/interface');

  describe('InterfaceView', function() {
    return beforeEach(function() {
      return this.view = new InterfaceView();
    });
  });
  
}});

window.require.define({"test/views/webfits_test": function(exports, require, module) {
  var WebfitsView;

  WebfitsView = require('views/webfits');

  describe('WebfitsView', function() {
    return beforeEach(function() {
      return this.view = new WebfitsView();
    });
  });
  
}});

window.require('test/views/app_view_test');
window.require('test/views/filter_test');
window.require('test/views/fits_test');
window.require('test/views/interface_test');
window.require('test/views/webfits_test');
