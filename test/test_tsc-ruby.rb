require 'test/unit'
require 'tsc-ruby'


class TestTypeScriptRuby < Test::Unit::TestCase
  def test_compile_file_in_success
    file = File.expand_path('data/hello.ts', File.dirname(__FILE__))
    subject = TypeScript::Ruby.compile_file(file)

    assert { subject.exit_status == 0 }
    assert { subject.success? }
    assert { subject.js == %Q{console.log("Hello TypeScript");\n} }
    assert { subject.stdout == '' }
    assert { subject.stderr == '' }
  end

  def test_compile_file_in_failure
    file = File.expand_path('data/bad.ts', File.dirname(__FILE__))
    subject = TypeScript::Ruby.compile_file(file)

    assert { subject.exit_status != 0 }
    assert { !subject.success? }
    assert { subject.stdout != '' || subject.stderr != '' }
  end

  def test_compile_file_with_es5
    file = File.expand_path('data/es5.ts', File.dirname(__FILE__))
    subject = TypeScript::Ruby.compile_file(file, '--target', 'ES5')

    assert { subject.success? }
  end

  def test_compile
    subject = TypeScript::Ruby.compile('class T { say() { console.log("Hello, world!") } }')

    assert { subject != '' }
    assert { subject != nil }
  end

  def test_compile_with_es5
    subject = TypeScript::Ruby.compile('class T { get name() { return "foo" } }', '--target', 'ES5')

    assert { subject != '' }
    assert { subject != nil }
  end

end
