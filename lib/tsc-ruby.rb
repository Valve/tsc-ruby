require 'tmpdir'
require 'tempfile'
require 'tsrc'
require 'tsc-ruby/version'
require 'tsc-ruby/compile_result'
require 'open3'

module TypeScript
  module Ruby
    class NodeNotFound < StandardError
    end

    class << self

      def tsc_version
        TypeScript::Src.version
      end

      def tsc(*args)
        cmd = ['node', TypeScript::Src.tsc_path.to_s, *args]
        Open3.capture3(*cmd)
      rescue Errno::ENOENT => e
        raise '`node` executable not found in PATH' if e.message == 'No such file or directory - node'
      end


      # Compile TypeScript string to JavaScript string
      # @param [String] script TypeScript to be compiled
      # @return [String] compiled JavaScript
      def compile(script, *tsc_options)
        script = script.read if script.respond_to?(:read)
        input_file = Tempfile.new(%w(tsc-ruby .ts))
        begin
          input_file.write(script)
          input_file.close
          result = compile_file(input_file.path, *tsc_options)
          if result.success?
            result.js
          else
            raise result.stderr + result.stdout
          end
        ensure
          input_file.unlink
        end
      end

      # Compile TypeScript script file to JavaScript script file.
      #
      # Compilation is a one to one process, not implicit concatenation of referenced dependencies is performed.
      #
      # @param [String] TypeScript script file
      # @return [TypeScript::Ruby::CompileResult] compile result
      def compile_file(input_file_path, *tsc_options)
        Dir.mktmpdir do |output_dir|
          stdout, stderr, exit_status = tsc(*tsc_options, '--outDir', output_dir, input_file_path)
          # now input file is in output_dir but with a .js extension
          output_file_path = File.join(output_dir, File.basename(input_file_path, '.ts')) + '.js'
          raise "Compiled JS file not found: #{output_file_path}" unless File.exist? output_file_path
          output_js = File.read(output_file_path)
          CompileResult.new(output_js, exit_status, stdout, stderr)
        end
      end
    end
  end
end
