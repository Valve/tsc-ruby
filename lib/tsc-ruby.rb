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
        js_file = Tempfile.new(%w(tsc-ruby .ts))
        begin
          js_file.write(source)
          js_file.close
          result = compile_file(js_file.path, *tsc_options)
          if result.success?
            result.js
          else
            raise result.stderr + result.stdout
          end
        ensure
          js_file.unlink
        end
      end

      private

      # Compile TypeScript source file to JavaScript source file.
      #
      # Compilation is a one to one process, not implicit concatenation of referenced dependencies is performed.
      #
      # @param [String] source_file TypeScript source file
      # @return [TypeScript::Ruby::CompileResult] compile result
      def compile_file(source_file, *tsc_options)
        Dir.mktmpdir do |output_dir|
          stdout, stderr, exit_status = tsc(*tsc_options, '--outDir', output_dir, source_file)
          output_file = "#{File.join(output_dir, File.basename(source_file, '.ts'))}.js"
          output_js = File.exist?(output_file) ? File.read(output_file) : nil
          CompileResult.new(output_js, exit_status, stdout, stderr)
        end
      end
    end
  end
end
