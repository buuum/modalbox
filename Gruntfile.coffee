module.exports = (grunt) ->
  grunt.file.expand('node_modules/grunt-*/tasks').forEach grunt.loadTasks

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    uglify:
      app:
        files:
          'modalbox/js/modalbox.min.js': 'modalbox/js/modalbox.js'

    coffee:
      compile:
        options:
          bare: true
        expand: true
        cwd: "src/coffee"
        src: "**/**/*.coffee"
        dest: "modalbox/js"
        ext: '.js'

    cssmin:
      target:
        files:
          'modalbox/css/main.css': 'src/css/app.css'

    compass:
      dist:
        options:
          sassDir: "src/sass"
          cssDir: "src/css"


  grunt.registerTask 'buildcoffee', 'Generamos Coffee', =>
    grunt.task.run ['coffee', 'uglify:app']
    return

  grunt.registerTask 'buildsass', 'Generamos SASS', =>
    grunt.task.run ['compass', 'cssmin']
    return