{spawn, exec} = require 'child_process'

task 'lib', 'Generate the library from the src', ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()
