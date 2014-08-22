BufferedProcess = require './buffered-process'

module.exports =
  class ShellRunner
    processor: BufferedProcess

    constructor: (params) ->
      @initialize(params)

    initialize: (params) ->
      @params = params || throw "Missing ::params argument"
      @write = params.write || throw "Missing ::write parameter"
      @exit = params.exit || throw "Missing ::exit parameter"
      @command = params.command || throw "Missing ::command parameter"

    run: ->
      fullCommand = "cd #{@params.cwd()} && #{@params.command()}; exit\n"
      @process = @newProcess(fullCommand)

    kill: ->
      if @process?
        @process.kill('SIGKILL')

    stdout: (output) =>
      @params.write output

    stderr: (output) =>
      @params.write output

    newProcess: (testCommand) ->
      command = 'bash'
      args = ['-c', testCommand]
      options = { cwd: @params.cwd }
      params = { command, args, options, @stdout, @stderr, @exit }
      outputCharacters = true
      process = new @processor params, outputCharacters
      process
