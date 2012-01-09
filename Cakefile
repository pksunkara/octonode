{spawn, exec} = require 'child_process'

task 'lib', 'Generate the library from the src', ->
  coffee = spawn 'node_modules/.bin/coffee', ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()

task 'watch', 'Generate the library from the src and watch for changes', ->
  coffee = spawn 'node_modules/.bin/coffee', ['-c','-w', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()

