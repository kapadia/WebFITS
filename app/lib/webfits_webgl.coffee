WebFitsApi  = require 'lib/webfits_api'
Shaders     = require 'lib/shaders'

class WebFitsWebGlApi extends WebFitsApi
  
  constructor: ->
    console.log 'WebFitsApi for WebGL'
  
  # Code using this function must check if a context is returned
  getContext: (canvas) ->
    
    # Initialize context
    for name in ['webgl', 'experimental-webgl']
      try
        context = canvas.getContext(name)
        context.viewport(0, 0, canvas.width, canvas.height)
      catch e
      break if (context)
    
    return null unless context
    
    # Check float extension support on GPU
    ext = @_getExtension(context)
    return null unless ext
    
    # Initialize shaders
    vertexShader = @_loadShader(context, Shaders.vertex, context.VERTEX_SHADER)
    return null unless vertexShader
    
    fragShader = @_loadShader(context, Shaders.fragment, context.FRAGMENT_SHADER)
    return null unless fragShader
    
    colorShader = @_loadShader(context, Shaders.lupton, context.FRAGMENT_SHADER)
    return null unless colorShader
    
    # Create the program
    @program1 = @_createProgram(context, [vertexShader, fragShader])
    return null unless @program1
    @program2 = @_createProgram(context, [vertexShader, colorShader])
    return null unless @program2
    
    for program in [@program2, @program1]
      context.useProgram(program)
      
      # Grab attribute and uniform locations
      positionLocation  = context.getAttribLocation(program, 'a_position')
      texCoordLocation  = context.getAttribLocation(program, 'a_textureCoord')
      extremesLocation  = context.getUniformLocation(program, 'u_extremes')
      offsetLocation    = context.getUniformLocation(program, 'u_offset')
      scaleLocation     = context.getUniformLocation(program, 'u_scale')
    
      # TODO: Using sample data CFHTLS 26.  Global min and max precomputed and hard coded here.
      context.uniform2f(extremesLocation, -2632.8103, 17321.828)
      context.uniform2f(offsetLocation, -401 / 2, -401 / 2)
      context.uniform1f(scaleLocation, 2 / 401)
    
    # Create texture coordinate buffer
    texCoordBuffer = context.createBuffer()
    context.bindBuffer(context.ARRAY_BUFFER, texCoordBuffer)
    context.bufferData(
      context.ARRAY_BUFFER,
      new Float32Array([0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]),
      context.STATIC_DRAW
    )
    context.enableVertexAttribArray(texCoordLocation)
    context.vertexAttribPointer(texCoordLocation, 2, context.FLOAT, false, 0, 0)
    
    # Create textures
    for i in [0..2]
      context.activeTexture(context["TEXTURE#{i}"])
      texture = context.createTexture()
      context.bindTexture(context.TEXTURE_2D, texture)
      context.texParameteri(context.TEXTURE_2D, context.TEXTURE_WRAP_S, context.CLAMP_TO_EDGE)
      context.texParameteri(context.TEXTURE_2D, context.TEXTURE_WRAP_T, context.CLAMP_TO_EDGE)
      context.texParameteri(context.TEXTURE_2D, context.TEXTURE_MIN_FILTER, context.NEAREST)
      context.texParameteri(context.TEXTURE_2D, context.TEXTURE_MAG_FILTER, context.NEAREST)
    
    buffer = context.createBuffer()
    context.bindBuffer(context.ARRAY_BUFFER, buffer)
    context.enableVertexAttribArray(positionLocation)
    context.vertexAttribPointer(positionLocation, 2, context.FLOAT, false, 0, 0)
    @_setRectangle(context, 0, 0, 401, 401)
    context.drawArrays(context.TRIANGLES, 0, 6)
    
    return context
    
  # Using underscore convention for 'private' methods
  _getExtension: (gl) ->
    return gl.getExtension('OES_texture_float')
  
  # Creates, compiles and checks for error when loading shader
  _loadShader: (gl, source, type) ->
    shader = gl.createShader(type)
    gl.shaderSource(shader, source)
    gl.compileShader(shader)
    
    compiled = gl.getShaderParameter(shader, gl.COMPILE_STATUS)
    unless compiled
      lastError = gl.getShaderInfoLog(shader)
      throw "Error compiling shader #{shader}: #{lastError}"
      gl.deleteShader(shader)
      return null
    
    return shader
    
  # Create the WebGL program
  _createProgram: (gl, shaders) ->
    program = gl.createProgram()
    for shader in shaders
      gl.attachShader(program, shader)
    
    gl.linkProgram(program)
    
    linked = gl.getProgramParameter(program, gl.LINK_STATUS)
    unless linked
      throw "Error in program linking: #{gl.getProgramInfoLog(program)}"
      gl.deleteProgram(program)
      return null
    
    return program

  # Set a buffer with viewport width and height
  _setRectangle: (gl, x, y, width, height) ->
      [x1, x2] = [x, x + width]
      [y1, y2] = [y, y + height]
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([x1, y1, x2, y1, x1, y2, x1, y2, x2, y1, x2, y2]), gl.STATIC_DRAW)
  
  # Set scale for a channel in the color composite image
  setScale: (gl, band, scale) ->
    gl.useProgram(@program2)
    
    location = gl.getUniformLocation(@program2, "u_#{band}scale")
    gl.uniform1f(location, scale)
    gl.drawArrays(gl.TRIANGLES, 0, 6)
  
  setSky: (gl, band, sky) ->
    gl.useProgram(@program2)
    
    location = gl.getUniformLocation(@program2, "u_#{band}sky")
    gl.uniform1f(location, sky)
    
  setMax: (gl, band, max) ->
    gl.useProgram(@program2)
    
    location = gl.getUniformLocation(@program2, "u_#{band}max")
    gl.uniform1f(location, max)
  
  # Set the alpha parameter for the Lupton algorithm
  setAlpha: (gl, value) =>
    gl.useProgram(@program2)
    
    location = gl.getUniformLocation(@program2, 'u_alpha')
    gl.uniform1f(location, value)
    gl.drawArrays(gl.TRIANGLES, 0, 6)
  
  # Set the Q parameter for the Lupton algorithm
  setQ: (gl, value) =>
    gl.useProgram(@program2)
    
    location = gl.getUniformLocation(@program2, 'u_Q')
    gl.uniform1f(location, value)
    gl.drawArrays(gl.TRIANGLES, 0, 6)
    
  setColorSaturation: (gl, value) =>
    gl.useProgram(@program2)
    
    location = gl.getUniformLocation(@program2, 'u_colorsat')
    gl.uniform1f(location, value)
    gl.drawArrays(gl.TRIANGLES, 0, 6)
  
  drawGrayScale: (gl, data) ->
    gl.useProgram(@program1)
    gl.activeTexture(gl.TEXTURE0)
    
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.LUMINANCE, 401, 401, 0, gl.LUMINANCE, gl.FLOAT, data)
    gl.drawArrays(gl.TRIANGLES, 0, 6)
  
  # Pass three arrays to three GPU textures
  drawColor: (gl, arr) ->
    gl.useProgram(@program2)
    
    for i in [0..2]
      gl.activeTexture(gl["TEXTURE#{i}"])
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.LUMINANCE, 401, 401, 0, gl.LUMINANCE, gl.FLOAT, arr[i])
    
    gl.drawArrays(gl.TRIANGLES, 0, 6)
    
  
module.exports = WebFitsWebGlApi