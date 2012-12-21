exports.config =
  
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor/
        'test/javascripts/test.js': /^test(\/|\\)(?!vendor)/
        'test/javascripts/test-vendor.js': /^test(\/|\\)(?=vendor)/
      order:
        # Files in `vendor` directories are compiled before other files
        # even if they aren't specified in order.
        before: [
          'vendor/scripts/jquery-1.8.3.js'
          'vendor/scripts/lodash-1.0.0-rc.2.js'
          'vendor/scripts/backbone-0.9.9.js'
          'vendor/scripts/fits.js'
        ]

    stylesheets:
      joinTo: 'stylesheets/app.css'
      order:
        before: ['vendor/styles/normalize.css']
        after: ['vendor/styles/helpers.css']

    templates:
      joinTo: 'javascripts/app.js'