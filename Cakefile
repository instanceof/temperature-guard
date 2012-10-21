{exec} = require 'child_process'
task 'build', 'Build project from server.coffee to server.js', ->
  exec 'coffee --compile server.coffee', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
