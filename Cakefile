{spawn, exec} = require 'child_process'

task 'lib', 'Generate the library from the src', ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()

task 'docs', 'Generate the documentation from the src', ->
  exec([
    'rm -rf docs'
    'for i in $(find src -name *.coffee)'
    'do mkdir -p $(dirname $i | sed -s "s/src/docs/")'
    '  docco $i'
    '  dirs=$i; ext=""'
    '  while expr $(dirname $dirs) != "src"'
    '  do dirs=$(dirname $dirs)'
    '    ext="..\\/$ext"'
    '  done'
    '  ext=$ext"docco.css"'
    '  file="docs/"$(basename $i | sed -s "s/coffee/html/")'
    '  sed -i "s/docco.css/$ext/" $file'
    '  mv $file $(echo $i | sed -s "s/coffee/html/;s/src/docs/")'
    'done'
  ].join('; '), (err) ->
    throw err if err
  )
