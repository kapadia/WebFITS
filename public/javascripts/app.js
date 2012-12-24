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

window.require.define({"initialize": function(exports, require, module) {
  var _ref, _ref1, _ref2, _ref3, _ref4;

  if ((_ref = this.WebFITS) == null) {
    this.WebFITS = {};
  }

  if ((_ref1 = WebFITS.Routers) == null) {
    WebFITS.Routers = {};
  }

  if ((_ref2 = WebFITS.Views) == null) {
    WebFITS.Views = {};
  }

  if ((_ref3 = WebFITS.Models) == null) {
    WebFITS.Models = {};
  }

  if ((_ref4 = WebFITS.Collections) == null) {
    WebFITS.Collections = {};
  }

  $(function() {
    var AppView;
    require('lib/app_helpers');
    WebFITS.Views.AppView = new (AppView = require('views/app_view'));
    return Backbone.history.start({
      pushState: true
    });
  });
  
}});

window.require.define({"lib/app_helpers": function(exports, require, module) {
  
  (function() {
    Swag.Config.partialsPath = '../views/templates/';
    return (function() {
      var console, dummy, method, methods, _results;
      console = window.console = window.console || {};
      method = void 0;
      dummy = function() {};
      methods = 'assert,count,debug,dir,dirxml,error,exception,\
                 group,groupCollapsed,groupEnd,info,log,markTimeline,\
                 profile,profileEnd,time,timeEnd,trace,warn'.split(',');
      _results = [];
      while (method = methods.pop()) {
        _results.push(console[method] = console[method] || dummy);
      }
      return _results;
    })();
  })();
  
}});

window.require.define({"lib/collection": function(exports, require, module) {
  var Collection,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Collection = (function(_super) {

    __extends(Collection, _super);

    function Collection() {
      return Collection.__super__.constructor.apply(this, arguments);
    }

    Collection.prototype.resetSilent = function(models) {
      return this.reset(models, {
        silent: true
      });
    };

    return Collection;

  })(Backbone.Collection);
  
}});

window.require.define({"lib/model": function(exports, require, module) {
  var Model,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  module.exports = Model = (function(_super) {

    __extends(Model, _super);

    function Model() {
      return Model.__super__.constructor.apply(this, arguments);
    }

    Model.prototype.setSilent = function(attributes) {
      return this.set(attributes, {
        silent: true
      });
    };

    Model.prototype.push = function() {
      var attr, attribute, obj, values;
      attribute = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      obj = {};
      attr = this.get(attribute);
      attr.push.apply(attr, values);
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.pop = function(attribute) {
      var attr, obj;
      obj = {};
      attr = this.get(attribute);
      attr.pop();
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.reverse = function(attribute) {
      var attr, obj;
      obj = {};
      attr = this.get(attribute);
      attr.reverse();
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.shift = function(attribute) {
      var attr, obj;
      obj = {};
      attr = this.get(attribute);
      attr.shift();
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.unshift = function() {
      var attr, attribute, obj, values;
      attribute = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      obj = {};
      attr = this.get(attribute);
      attr.unshift.apply(attr, values);
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.splice = function() {
      var attr, attribute, obj, values;
      attribute = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      obj = {};
      attr = this.get(attribute);
      attr.splice.apply(attr, values);
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.add = function() {
      var attr, attribute, obj, value, values, _i, _len;
      attribute = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      obj = {};
      attr = this.get(attribute);
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        value = values[_i];
        attr += value;
      }
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.subtract = function() {
      var attr, attribute, obj, value, values, _i, _len;
      attribute = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      obj = {};
      attr = this.get(attribute);
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        value = values[_i];
        attr -= value;
      }
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.divide = function() {
      var attr, attribute, obj, value, values, _i, _len;
      attribute = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      obj = {};
      attr = this.get(attribute);
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        value = values[_i];
        attr /= value;
      }
      obj[attribute] = attr;
      return this.set(obj);
    };

    Model.prototype.multiply = function() {
      var attr, attribute, obj, value, values, _i, _len;
      attribute = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      obj = {};
      attr = this.get(attribute);
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        value = values[_i];
        attr *= value;
      }
      obj[attribute] = attr;
      return this.set(obj);
    };

    return Model;

  })(Backbone.Model);
  
}});

window.require.define({"lib/shaders": function(exports, require, module) {
  var WebGlShaders;

  WebGlShaders = {
    vertex: ["attribute vec2 a_position;", "attribute vec2 a_textureCoord;", "uniform vec2 u_offset;", "uniform float u_scale;", "varying vec2 v_textureCoord;", "void main() {", "vec2 position = a_position + u_offset;", "position = position * u_scale;", "gl_Position = vec4(position, 0.0, 1.0);", "v_textureCoord = a_textureCoord;", "}"].join("\n"),
    fragment: ["precision mediump float;", "uniform sampler2D u_tex;", "uniform vec2 u_extremes;", "varying vec2 v_textureCoord;", "float arcsinh(float value) {", "return log(value + sqrt(1.0 + value * value));", "}", "void main() {", "vec4 pixel_v = texture2D(u_tex, v_textureCoord);", "float min = arcsinh(u_extremes[0]);", "float max = arcsinh(u_extremes[1]);", "float value = arcsinh(pixel_v[0]);", "float pixel = (value - min) / (max - min);", "gl_FragColor = vec4(pixel, pixel, pixel, 1.0);", "}"].join("\n"),
    lupton: ["precision mediump float;", "uniform sampler2D u_tex_g;", "uniform sampler2D u_tex_r;", "uniform sampler2D u_tex_i;", "uniform vec2 u_extremes;", "uniform float u_gscale;", "uniform float u_rscale;", "uniform float u_iscale;", "uniform float u_alpha;", "uniform float u_Q;", "varying vec2 v_textureCoord;", "float arcsinh(float value) {", "return log(value + sqrt(1.0 + value * value));", "}", "float lupton_asinh(float mean, float Q, float alpha) {", "return arcsinh(alpha * Q * mean) / (Q * mean);", "}", "void main() {", "vec4 pixel_v_g = texture2D(u_tex_g, v_textureCoord);", "vec4 pixel_v_r = texture2D(u_tex_r, v_textureCoord);", "vec4 pixel_v_i = texture2D(u_tex_i, v_textureCoord);", "float r = pixel_v_i[0] * u_iscale;", "float g = pixel_v_r[0] * u_rscale;", "float b = pixel_v_g[0] * u_gscale;", "float I = r + g + b + 1e-10;", "float factor = lupton_asinh(I, u_Q, u_alpha);", "float R = r * factor;", "float G = g * factor;", "float B = b * factor;", "gl_FragColor = vec4(R, G, B, 1.0);", "}"].join("\n")
  };

  module.exports = WebGlShaders;
  
}});

window.require.define({"lib/view": function(exports, require, module) {
  var Model, View,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Model = require('lib/model');

  module.exports = View = (function(_super) {

    __extends(View, _super);

    function View() {
      return View.__super__.constructor.apply(this, arguments);
    }

    View.prototype.debug = false;

    View.prototype.startDebugging = function() {
      this.on("" + this.cid + ":initialize", function() {
        return console.debug("Initialized " + this.name, this);
      });
      this.on("" + this.cid + ":render", function() {
        return console.debug("Rendered " + this.name, this);
      });
      this.on("" + this.cid + ":update", function() {
        return console.debug("Updated " + this.name, this);
      });
      return this.on("" + this.cid + ":destroy", function() {
        return console.debug("Destroyed " + this.name, this);
      });
    };

    View.prototype.type = 'view';

    View.prototype.name = null;

    View.prototype.autoRender = false;

    View.prototype.rendered = false;

    View.prototype.model = new Model();

    View.prototype.template = function() {
      return '';
    };

    View.prototype.html = function(dom) {
      this.$el.html(dom);
      this.trigger("" + this.cid + ":" + (this.rendered ? 'update' : 'render'), this);
      return this.$el;
    };

    View.prototype.append = function(dom) {
      this.$el.append(dom);
      this.trigger("" + this.cid + ":" + (this.rendered ? 'update' : 'render'), this);
      return this.$el;
    };

    View.prototype.prepend = function(dom) {
      this.$el.prepend(dom);
      this.trigger("" + this.cid + ":" + (this.rendered ? 'update' : 'render'), this);
      return this.$el;
    };

    View.prototype.after = function(dom) {
      this.$el.after(dom);
      this.trigger("" + this.cid + ":update", this);
      return this.$el;
    };

    View.prototype.before = function(dom) {
      this.$el.after(dom);
      this.trigger("" + this.cid + ":update", this);
      return this.$el;
    };

    View.prototype.css = function(css) {
      this.$el.css(css);
      this.trigger("" + this.cid + ":update", this);
      return this.$el;
    };

    View.prototype.find = function(selector) {
      return this.$el.find(selector);
    };

    View.prototype.delegate = function(event, selector, handler) {
      if (arguments.length === 2) {
        handler = selector;
      }
      handler = handler.bind(this);
      if (arguments.length === 2) {
        return this.$el.on(event, handler);
      } else {
        return this.$el.on(event, selector, handler);
      }
    };

    View.prototype.bootstrap = function() {};

    View.prototype.initialize = function() {
      this.bootstrap();
      this.name = this.name || this.constructor.name;
      if (this.debug === true) {
        this.startDebugging();
      }
      if (this.autoRender === true) {
        this.render();
      }
      return this.trigger("" + this.cid + ":initialize", this);
    };

    View.prototype.getRenderData = function() {
      var _ref;
      return (_ref = this.model) != null ? _ref.toJSON() : void 0;
    };

    View.prototype.render = function() {
      this.trigger("" + this.cid + ":render:before", this);
      this.$el.attr('data-cid', this.cid);
      this.html(this.template(this.getRenderData()));
      this.rendered = true;
      this.trigger("" + this.cid + ":render:after", this);
      return this;
    };

    View.prototype.destroy = function(keepDOM) {
      var _ref;
      if (keepDOM == null) {
        keepDOM = false;
      }
      this.trigger("" + this.cid + ":destroy:before", this);
      if (keepDOM) {
        this.dispose();
      } else {
        this.remove();
      }
      if ((_ref = this.model) != null) {
        _ref.destroy();
      }
      return this.trigger("" + this.cid + ":destroy:after", this);
    };

    return View;

  })(Backbone.View);
  
}});

window.require.define({"lib/webfits_api": function(exports, require, module) {
  var WebFitsApi,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  WebFitsApi = (function() {

    WebFitsApi.prototype.scales = {};

    function WebFitsApi() {
      this.draw = __bind(this.draw, this);

      this.setScale = __bind(this.setScale, this);

      this.addFrame = __bind(this.addFrame, this);
      console.log('WebFitsApi for WebGL');
    }

    WebFitsApi.prototype.setup = function(elem, width, height) {
      var canvas;
      console.log('setup');
      canvas = document.createElement('canvas');
      canvas.setAttribute('class', 'viewer');
      canvas.setAttribute('width', width);
      canvas.setAttribute('height', height);
      elem.appendChild(canvas);
      return canvas;
    };

    WebFitsApi.prototype.addFrame = function(fits) {
      return console.log('addFrame');
    };

    WebFitsApi.prototype.setScale = function(ctx, band, scale) {
      return this.scales[band] = scale;
    };

    WebFitsApi.prototype.draw = function() {
      return console.log('draw');
    };

    return WebFitsApi;

  })();

  module.exports = WebFitsApi;
  
}});

window.require.define({"lib/webfits_canvas": function(exports, require, module) {
  var WebFitsApi, WebFitsCanvasApi,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WebFitsApi = require('lib/webfits_api');

  WebFitsCanvasApi = (function(_super) {

    __extends(WebFitsCanvasApi, _super);

    function WebFitsCanvasApi() {
      console.log('WebFitsApi for Canvas');
    }

    WebFitsCanvasApi.prototype.getContext = function(canvas) {
      return canvas.getContext('2d');
    };

    return WebFitsCanvasApi;

  })(WebFitsApi);

  module.exports = WebFitsCanvasApi;
  
}});

window.require.define({"lib/webfits_webgl": function(exports, require, module) {
  var Shaders, WebFitsApi, WebFitsWebGlApi,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WebFitsApi = require('lib/webfits_api');

  Shaders = require('lib/shaders');

  WebFitsWebGlApi = (function(_super) {

    __extends(WebFitsWebGlApi, _super);

    function WebFitsWebGlApi() {
      this.setQ = __bind(this.setQ, this);

      this.setAlpha = __bind(this.setAlpha, this);
      console.log('WebFitsApi for WebGL');
    }

    WebFitsWebGlApi.prototype.getContext = function(canvas) {
      var buffer, colorShader, context, ext, extremesLocation, fragShader, i, name, offsetLocation, positionLocation, program, scaleLocation, texCoordBuffer, texCoordLocation, texture, vertexShader, _i, _j, _k, _len, _len1, _ref, _ref1;
      _ref = ['webgl', 'experimental-webgl'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        try {
          context = canvas.getContext(name);
          context.viewport(0, 0, canvas.width, canvas.height);
        } catch (e) {

        }
        if (context) {
          break;
        }
      }
      if (!context) {
        return null;
      }
      ext = this._getExtension(context);
      if (!ext) {
        return null;
      }
      vertexShader = this._loadShader(context, Shaders.vertex, context.VERTEX_SHADER);
      if (!vertexShader) {
        return null;
      }
      fragShader = this._loadShader(context, Shaders.fragment, context.FRAGMENT_SHADER);
      if (!fragShader) {
        return null;
      }
      colorShader = this._loadShader(context, Shaders.lupton, context.FRAGMENT_SHADER);
      if (!colorShader) {
        return null;
      }
      this.program1 = this._createProgram(context, [vertexShader, fragShader]);
      if (!this.program1) {
        return null;
      }
      this.program2 = this._createProgram(context, [vertexShader, colorShader]);
      if (!this.program2) {
        return null;
      }
      _ref1 = [this.program2, this.program1];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        program = _ref1[_j];
        context.useProgram(program);
        positionLocation = context.getAttribLocation(program, 'a_position');
        texCoordLocation = context.getAttribLocation(program, 'a_textureCoord');
        extremesLocation = context.getUniformLocation(program, 'u_extremes');
        offsetLocation = context.getUniformLocation(program, 'u_offset');
        scaleLocation = context.getUniformLocation(program, 'u_scale');
        context.uniform2f(extremesLocation, -2632.8103, 17321.828);
        context.uniform2f(offsetLocation, -401 / 2, -401 / 2);
        context.uniform1f(scaleLocation, 2 / 401);
      }
      texCoordBuffer = context.createBuffer();
      context.bindBuffer(context.ARRAY_BUFFER, texCoordBuffer);
      context.bufferData(context.ARRAY_BUFFER, new Float32Array([0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]), context.STATIC_DRAW);
      context.enableVertexAttribArray(texCoordLocation);
      context.vertexAttribPointer(texCoordLocation, 2, context.FLOAT, false, 0, 0);
      for (i = _k = 0; _k <= 2; i = ++_k) {
        context.activeTexture(context["TEXTURE" + i]);
        texture = context.createTexture();
        context.bindTexture(context.TEXTURE_2D, texture);
        context.texParameteri(context.TEXTURE_2D, context.TEXTURE_WRAP_S, context.CLAMP_TO_EDGE);
        context.texParameteri(context.TEXTURE_2D, context.TEXTURE_WRAP_T, context.CLAMP_TO_EDGE);
        context.texParameteri(context.TEXTURE_2D, context.TEXTURE_MIN_FILTER, context.NEAREST);
        context.texParameteri(context.TEXTURE_2D, context.TEXTURE_MAG_FILTER, context.NEAREST);
      }
      buffer = context.createBuffer();
      context.bindBuffer(context.ARRAY_BUFFER, buffer);
      context.enableVertexAttribArray(positionLocation);
      context.vertexAttribPointer(positionLocation, 2, context.FLOAT, false, 0, 0);
      this._setRectangle(context, 0, 0, 401, 401);
      context.drawArrays(context.TRIANGLES, 0, 6);
      return context;
    };

    WebFitsWebGlApi.prototype._getExtension = function(gl) {
      return gl.getExtension('OES_texture_float');
    };

    WebFitsWebGlApi.prototype._loadShader = function(gl, source, type) {
      var compiled, lastError, shader;
      shader = gl.createShader(type);
      gl.shaderSource(shader, source);
      gl.compileShader(shader);
      compiled = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
      if (!compiled) {
        lastError = gl.getShaderInfoLog(shader);
        throw "Error compiling shader " + shader + ": " + lastError;
        gl.deleteShader(shader);
        return null;
      }
      return shader;
    };

    WebFitsWebGlApi.prototype._createProgram = function(gl, shaders) {
      var linked, program, shader, _i, _len;
      program = gl.createProgram();
      for (_i = 0, _len = shaders.length; _i < _len; _i++) {
        shader = shaders[_i];
        gl.attachShader(program, shader);
      }
      gl.linkProgram(program);
      linked = gl.getProgramParameter(program, gl.LINK_STATUS);
      if (!linked) {
        throw "Error in program linking: " + (gl.getProgramInfoLog(program));
        gl.deleteProgram(program);
        return null;
      }
      return program;
    };

    WebFitsWebGlApi.prototype._setRectangle = function(gl, x, y, width, height) {
      var x1, x2, y1, y2, _ref, _ref1;
      _ref = [x, x + width], x1 = _ref[0], x2 = _ref[1];
      _ref1 = [y, y + height], y1 = _ref1[0], y2 = _ref1[1];
      return gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([x1, y1, x2, y1, x1, y2, x1, y2, x2, y1, x2, y2]), gl.STATIC_DRAW);
    };

    WebFitsWebGlApi.prototype.setScale = function(gl, band, scale) {
      var location;
      console.log(band, scale);
      gl.useProgram(this.program2);
      location = gl.getUniformLocation(this.program2, "u_" + band + "scale");
      return gl.uniform1f(location, scale);
    };

    WebFitsWebGlApi.prototype.setAlpha = function(gl, value) {
      var location;
      gl.useProgram(this.program2);
      location = gl.getUniformLocation(this.program2, 'u_alpha');
      gl.uniform1f(location, value);
      return gl.drawArrays(gl.TRIANGLES, 0, 6);
    };

    WebFitsWebGlApi.prototype.setQ = function(gl, value) {
      var location;
      gl.useProgram(this.program2);
      location = gl.getUniformLocation(this.program2, 'u_Q');
      gl.uniform1f(location, value);
      return gl.drawArrays(gl.TRIANGLES, 0, 6);
    };

    WebFitsWebGlApi.prototype.drawGrayScale = function(gl, data) {
      gl.useProgram(this.program1);
      gl.activeTexture(gl.TEXTURE0);
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.LUMINANCE, 401, 401, 0, gl.LUMINANCE, gl.FLOAT, data);
      return gl.drawArrays(gl.TRIANGLES, 0, 6);
    };

    WebFitsWebGlApi.prototype.drawColor = function(gl, arr) {
      var i, _i;
      gl.useProgram(this.program2);
      for (i = _i = 0; _i <= 2; i = ++_i) {
        gl.activeTexture(gl["TEXTURE" + i]);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.LUMINANCE, 401, 401, 0, gl.LUMINANCE, gl.FLOAT, arr[i]);
      }
      return gl.drawArrays(gl.TRIANGLES, 0, 6);
    };

    return WebFitsWebGlApi;

  })(WebFitsApi);

  module.exports = WebFitsWebGlApi;
  
}});

window.require.define({"routers/app_router": function(exports, require, module) {
  var AppRouter,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  AppRouter = (function(_super) {

    __extends(AppRouter, _super);

    function AppRouter() {
      return AppRouter.__super__.constructor.apply(this, arguments);
    }

    AppRouter.prototype.routes = {
      '': function() {}
    };

    return AppRouter;

  })(Backbone.Router);

  module.exports = AppRouter;
  
}});

window.require.define({"views/Control": function(exports, require, module) {
  var ControlView, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('../lib/view');

  ControlView = (function(_super) {

    __extends(ControlView, _super);

    function ControlView() {
      this.initialize = __bind(this.initialize, this);
      return ControlView.__super__.constructor.apply(this, arguments);
    }

    ControlView.prototype.template = require('views/templates/control');

    ControlView.prototype.className = 'control';

    ControlView.prototype.events = {
      'click input[name="band"]': 'setBand',
      'change input[name="alpha"]': 'setAlpha',
      'change input[name="Q"]': 'setQ'
    };

    ControlView.prototype.initialize = function() {
      this.render();
      this.find('*').prop('disabled', 'disabled');
      this.ranges = this.find('input[type="range"]');
      this.alpha = this.find('input[name="alpha"] + .parameter');
      return this.Q = this.find('input[name="Q"] + .parameter');
    };

    ControlView.prototype.render = function() {
      return this.$el.append(this.template());
    };

    ControlView.prototype.ready = function() {
      this.find('*').removeProp('disabled');
      this.find('label[for="r"]').click();
      return this.setBand();
    };

    ControlView.prototype.setBand = function() {
      var band;
      console.log('setBand');
      band = this.find('input[name="band"]:checked + label')[0].dataset.band;
      if (band === 'gri') {
        this.ranges.removeAttr('disabled');
      } else {
        this.ranges.attr('disabled', 'disabled');
      }
      return this.trigger('change:band', band);
    };

    ControlView.prototype.setAlpha = function(e) {
      var val;
      val = e.target.value;
      this.alpha.text("α: " + val);
      this.alpha.offset({
        top: e.target.offsetTop - 10,
        left: 401 * val / 1
      });
      return this.trigger('change:alpha', val);
    };

    ControlView.prototype.setQ = function(e) {
      var val;
      val = e.target.value;
      this.Q.text("Q: " + val);
      this.Q.offset({
        top: e.target.offsetTop - 10,
        left: 401 * val / 100
      });
      return this.trigger('change:Q', val);
    };

    return ControlView;

  })(View);

  module.exports = ControlView;
  
}});

window.require.define({"views/DataSource": function(exports, require, module) {
  var DataSourceView, View,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('../lib/view');

  DataSourceView = (function(_super) {

    __extends(DataSourceView, _super);

    function DataSourceView() {
      return DataSourceView.__super__.constructor.apply(this, arguments);
    }

    DataSourceView.prototype.el = 'body.application';

    DataSourceView.prototype.template = require('views/templates/datasource');

    DataSourceView.prototype.className = 'DataSource';

    DataSourceView.prototype.events = {
      'click li.dataset': 'selectDataset'
    };

    DataSourceView.prototype.initialize = function() {
      console.log('DataSourceView');
      return this.render();
    };

    DataSourceView.prototype.render = function() {
      var i, num, prefixes, _i;
      prefixes = [];
      for (i = _i = 1; _i <= 30; i = ++_i) {
        num = String('0' + i).slice(-2);
        prefixes.push("CFHTLS_" + num);
      }
      return this.$el.append(this.template({
        source: prefixes
      }));
    };

    DataSourceView.prototype.selectDataset = function(e) {
      return this.trigger('change:dataset', e.target.textContent);
    };

    return DataSourceView;

  })(View);

  module.exports = DataSourceView;
  
}});

window.require.define({"views/WebFits": function(exports, require, module) {
  var ControlView, FitsView, View, WebFitsView,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('../lib/view');

  ControlView = require('views/Control');

  FitsView = require('views/fits');

  WebFitsView = (function(_super) {

    __extends(WebFitsView, _super);

    function WebFitsView() {
      this.setDataset = __bind(this.setDataset, this);

      this.onQChange = __bind(this.onQChange, this);

      this.onAlphaChange = __bind(this.onAlphaChange, this);

      this.onBandChange = __bind(this.onBandChange, this);

      this.onFitsReady = __bind(this.onFitsReady, this);
      return WebFitsView.__super__.constructor.apply(this, arguments);
    }

    WebFitsView.prototype.el = 'body.application';

    WebFitsView.prototype.template = require('views/templates/webfits');

    WebFitsView.prototype.className = 'webfits';

    WebFitsView.prototype.initialize = function() {
      this.render();
      this.control = new ControlView({
        el: this.find('.controls')
      });
      this.fits = new FitsView({
        el: this.find('.fits')
      });
      this.fits.on('fits:ready', this.onFitsReady);
      this.control.on('change:band', this.onBandChange);
      this.control.on('change:alpha', this.onAlphaChange);
      return this.control.on('change:Q', this.onQChange);
    };

    WebFitsView.prototype.render = function() {
      return this.$el.append(this.template());
    };

    WebFitsView.prototype.onFitsReady = function() {
      return this.control.ready();
    };

    WebFitsView.prototype.onBandChange = function(band) {
      return this.fits.selectBand(band);
    };

    WebFitsView.prototype.onAlphaChange = function(value) {
      return this.fits.updateAlpha(value);
    };

    WebFitsView.prototype.onQChange = function(value) {
      return this.fits.updateQ(value);
    };

    WebFitsView.prototype.setDataset = function(value) {
      return this.fits.getData(value);
    };

    return WebFitsView;

  })(View);

  module.exports = WebFitsView;
  
}});

window.require.define({"views/app_view": function(exports, require, module) {
  var AppRouter, AppView, DataSource, View, WebFitsView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('lib/view');

  AppRouter = require('routers/app_router');

  WebFitsView = require('views/WebFits');

  DataSource = require('views/DataSource');

  AppView = (function(_super) {

    __extends(AppView, _super);

    function AppView() {
      return AppView.__super__.constructor.apply(this, arguments);
    }

    AppView.prototype.el = 'body.application';

    AppView.prototype.initialize = function() {
      var _ref;
      this.router = new AppRouter();
      if (typeof WebFITS !== "undefined" && WebFITS !== null) {
        if ((_ref = WebFITS.Routers) != null) {
          _ref.AppRouter = this.router;
        }
      }
      this.webfits = new WebFitsView();
      this.datasource = new DataSource();
      return this.datasource.on('change:dataset', this.webfits.setDataset);
    };

    return AppView;

  })(View);

  module.exports = AppView;
  
}});

window.require.define({"views/fits": function(exports, require, module) {
  var FitsView, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('../lib/view');

  FitsView = (function(_super) {

    __extends(FitsView, _super);

    FitsView.prototype.template = require('views/templates/fits');

    FitsView.prototype.className = 'fits';

    FitsView.prototype.bands = ['u', 'g', 'r', 'i', 'z'];

    FitsView.prototype.wavelengths = {
      'u.MP9301': 3740,
      'g.MP9401': 4870,
      'r.MP9601': 6250,
      'i.MP9701': 7700,
      'i.MP9702': 7700,
      'z.MP9801': 9000
    };

    function FitsView() {
      this.updateQ = __bind(this.updateQ, this);

      this.updateAlpha = __bind(this.updateAlpha, this);

      this.selectBand = __bind(this.selectBand, this);

      this.normalizeScales = __bind(this.normalizeScales, this);

      this.setScale = __bind(this.setScale, this);

      this.getData = __bind(this.getData, this);

      var canvas;
      console.log('FitsView');
      FitsView.__super__.constructor.apply(this, arguments);
      this.getApi();
      canvas = this.wfits.setup(this.el, 401, 401);
      this.ctx = this.wfits.getContext(canvas);
      if (this.ctx == null) {
        alert('Something went wrong initiaizing a WebGL context');
      }
    }

    FitsView.prototype.getApi = function() {
      var WebFitsApi, canvas, checkWebGL, context;
      if (typeof DataView === "undefined" || DataView === null) {
        alert('Sorry, update your browser');
      }
      canvas = document.createElement('canvas');
      context = canvas.getContext('webgl');
      if (context == null) {
        context = canvas.getContext('experimental-webgl');
      }
      checkWebGL = context != null;
      WebFitsApi = checkWebGL ? require('lib/webfits_webgl') : require('lib/webfits_canvas');
      return this.wfits = new WebFitsApi();
    };

    FitsView.prototype.render = function() {
      return this.$el.append(this.template());
    };

    FitsView.prototype.getData = function(id) {
      var FITS, band, dfs, xhr, xhrs, _fn, _i, _j, _len, _len1, _ref,
        _this = this;
      FITS = astro.FITS;
      this.fits = {};
      dfs = [];
      xhrs = [];
      _ref = this.bands;
      _fn = function(band) {
        var d, fname, fpath, xhr;
        fname = "" + id + "_" + band + "_sci.fits";
        fpath = "data/" + fname;
        d = new $.Deferred();
        dfs.push(d);
        xhr = new XMLHttpRequest();
        xhr.open('GET', fpath);
        xhr.responseType = 'arraybuffer';
        xhr.onload = function(e) {
          var fits;
          fits = new FITS.File(xhr.response);
          fits.getDataUnit().getFrame();
          _this.setScale(fits.getHDU());
          _this.fits[band] = fits;
          return d.resolve();
        };
        return xhrs.push(xhr);
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        band = _ref[_i];
        _fn(band);
      }
      for (_j = 0, _len1 = xhrs.length; _j < _len1; _j++) {
        xhr = xhrs[_j];
        xhr.send();
      }
      return $.when.apply(this, dfs).done(function(e) {
        _this.normalizeScales();
        return _this.trigger("fits:ready");
      });
    };

    FitsView.prototype.setScale = function(hdu) {
      var exptime, filter, scale, wavelength, zpoint;
      zpoint = hdu.header['PHOT_C'];
      exptime = hdu.header['EXPTIME'];
      filter = hdu.header['FILTER'];
      wavelength = this.wavelengths[filter];
      scale = Math.pow(10, zpoint + 2.5 * this.log10(wavelength) - 26.0);
      return hdu.header['SCALE'] = scale;
    };

    FitsView.prototype.log10 = function(x) {
      return Math.log(x) / Math.log(10);
    };

    FitsView.prototype.normalizeScales = function() {
      var avg, band, header, scale, _i, _j, _len, _len1, _ref, _ref1, _results;
      scale = 0;
      _ref = ['g', 'r', 'i'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        band = _ref[_i];
        scale += this.fits[band].getHDU().header['SCALE'];
      }
      avg = scale / 3;
      _ref1 = ['g', 'r', 'i'];
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        band = _ref1[_j];
        header = this.fits[band].getHDU().header;
        scale = header['SCALE'];
        header['NSCALE'] = scale / avg;
        _results.push(this.wfits.setScale(this.ctx, band, header['NSCALE']));
      }
      return _results;
    };

    FitsView.prototype.selectBand = function(band) {
      var arr, data, _i, _len, _ref;
      if (band === 'gri') {
        arr = [];
        _ref = band.split('');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          band = _ref[_i];
          data = this.fits[band].getDataUnit().data;
          arr.push(data);
        }
        return this.wfits.drawColor(this.ctx, arr);
      } else {
        data = this.fits[band].getDataUnit().data;
        return this.wfits.drawGrayScale(this.ctx, data);
      }
    };

    FitsView.prototype.updateAlpha = function(value) {
      return this.wfits.setAlpha(this.ctx, value);
    };

    FitsView.prototype.updateQ = function(value) {
      return this.wfits.setQ(this.ctx, value);
    };

    return FitsView;

  })(View);

  module.exports = FitsView;
  
}});

window.require.define({"views/templates/control": function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    


    return "<div class='bands'>\n  <input type='radio' name='band' id='gri' />\n  <label for='gri' data-band='gri'>g-r-i</label>\n\n  <input type='radio' name='band' id='u' />\n  <label for='u' data-band='u'>u</label>\n\n  <input type='radio' name='band' id='g' />\n  <label for='g' data-band='g'>g</label>\n\n  <input type='radio' name='band' id='r' />\n  <label for='r' data-band='r'>r</label>\n\n  <input type='radio' name='band' id='i' />\n  <label for='i' data-band='i'>i</label>\n\n  <input type='radio' name='band' id='z' />\n  <label for='z' data-band='z'>z</label>\n</div>\n\n<div class='parameters'>\n  <input type=\"range\" name=\"alpha\" min=\"0.01\" max=\"1\" step=\"0.01\" value=\"0.03\" disabled='disabled'>\n  <div class='parameter'>&alpha;: 0.03</div>\n  <input type=\"range\" name=\"Q\" min=\"0.01\" max=\"100\" step=\"0.01\" value=\"1\" disabled='disabled'>\n  <div class='parameter'>Q: 1</div>\n</input>";});
}});

window.require.define({"views/templates/datasource": function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var buffer = "", stack1, foundHelper, functionType="function", escapeExpression=this.escapeExpression, self=this, blockHelperMissing=helpers.blockHelperMissing;

  function program1(depth0,data) {
    
    var buffer = "";
    buffer += "\n  <li class='dataset'>";
    depth0 = typeof depth0 === functionType ? depth0() : depth0;
    buffer += escapeExpression(depth0) + "</li>\n";
    return buffer;}

    buffer += "<div class='datasource'>\n<ul>\n";
    foundHelper = helpers.source;
    if (foundHelper) { stack1 = foundHelper.call(depth0, {hash:{},inverse:self.noop,fn:self.program(1, program1, data)}); }
    else { stack1 = depth0.source; stack1 = typeof stack1 === functionType ? stack1() : stack1; }
    if (!helpers.source) { stack1 = blockHelperMissing.call(depth0, stack1, {hash:{},inverse:self.noop,fn:self.program(1, program1, data)}); }
    if(stack1 || stack1 === 0) { buffer += stack1; }
    buffer += "\n</ul>\n</div>";
    return buffer;});
}});

window.require.define({"views/templates/fits": function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var buffer = "";


    return buffer;});
}});

window.require.define({"views/templates/webfits": function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    


    return "<div class='webfits'>\n  <div class='controls'></div>\n  <div class='fits'></div>\n</div>";});
}});

