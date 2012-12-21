WebGlShaders =

  vertex: [
    "attribute vec2 a_position;",
    "attribute vec2 a_textureCoord;",

    "uniform vec2 u_offset;",
    "uniform float u_scale;",

    "varying vec2 v_textureCoord;",

    "void main() {",
      "vec2 position = a_position + u_offset;",
      "position = position * u_scale;",
      "gl_Position = vec4(position, 0.0, 1.0);",
    
      # Pass coordinate to fragment shader
      "v_textureCoord = a_textureCoord;",
    "}"
  ].join("\n")


  fragment: [
    "precision mediump float;",

    "uniform sampler2D u_tex;",
    "uniform vec2 u_extremes;",

    "varying vec2 v_textureCoord;",

    "float arcsinh(float value) {",
        "return log(value + sqrt(1.0 + value * value));",
    "}",

    "void main() {",
        "vec4 pixel_v = texture2D(u_tex, v_textureCoord);",

        "float min = arcsinh(u_extremes[0]);",
        "float max = arcsinh(u_extremes[1]);",
        "float value = arcsinh(pixel_v[0]);",

        "float pixel = (value - min) / (max - min);",

        "gl_FragColor = vec4(pixel, pixel, pixel, 1.0);",
    "}"
  ].join("\n")
  
  lupton: [
    "precision mediump float;",

    "uniform sampler2D u_tex_g;",
    "uniform sampler2D u_tex_r;",
    "uniform sampler2D u_tex_i;",
    
    "uniform vec2 u_extremes;",
    
    "uniform float u_gscale;",
    "uniform float u_rscale;",
    "uniform float u_iscale;",

    "uniform float u_alpha;",
    "uniform float u_Q;",

    "varying vec2 v_textureCoord;",

    "float arcsinh(float value) {",
      "return log(value + sqrt(1.0 + value * value));",
    "}",
    
    "float lupton_asinh(float mean, float Q, float alpha) {",
      "return arcsinh(alpha * Q * mean) / (Q * mean);"
    "}",
    
    "void main() {",
      "vec4 pixel_v_g = texture2D(u_tex_g, v_textureCoord);",
      "vec4 pixel_v_r = texture2D(u_tex_r, v_textureCoord);",
      "vec4 pixel_v_i = texture2D(u_tex_i, v_textureCoord);",
      
      # Store the current pixel value for each texture and apply scale
      "float r = pixel_v_i[0] * u_iscale;",
      "float g = pixel_v_r[0] * u_rscale;",
      "float b = pixel_v_g[0] * u_gscale;",
      
      # Compute the sum and factor
      "float I = r + g + b + 1e-10;",
      "float factor = lupton_asinh(I, u_Q, u_alpha);",
      
      # Apply factor
      "float R = r * factor;",
      "float G = g * factor;",
      "float B = b * factor;",
      
      "gl_FragColor = vec4(R, G, B, 1.0);",
    "}"
  ].join("\n")

module.exports = WebGlShaders
