fs = require 'fs'

class JadeCompiler
    lib: require 'jade'

    compile: (file, output) ->
        template = fs.readFileSync file
        fn = @lib.compile template,
            filename: file
        html = fn()
        fs.writeFileSync output, html

exports.JadeCompiler = new JadeCompiler
