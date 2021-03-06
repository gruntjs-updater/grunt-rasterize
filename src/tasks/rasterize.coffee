#
# * grunt-rasterize
# * https://github.com/logankoester/grunt-rasterize
# *
# * Copyright (c) 2013 Logan Koester
# * Licensed under the MIT license.
# 

fs = require 'fs'
async = require 'async'
Inkscape = require 'inkscape'

module.exports = (grunt) ->
  
  grunt.registerMultiTask 'rasterize', 'Convert a vector graphic into one or more raster images', ->

    rasterize = (out, done) =>
      grunt.log.write " -> #{out.path} "

      if out.width
        params = ['--export-png', "--export-width=#{out.width}"]
      else
        params = ['--export-png']

      ink = new Inkscape(params).on 'end', -> done()
      out = fs.createWriteStream(out.path)
      fs.createReadStream(@data.vector).pipe(ink).pipe(out)
      grunt.log.ok()

    grunt.log.subhead "Rasterizing #{@data.vector}"

    done = @async()
    async.eachSeries @data.raster, rasterize, (err) ->
      grunt.log.writeln()
      done()
