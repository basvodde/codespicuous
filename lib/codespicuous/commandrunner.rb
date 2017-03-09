
# encoding: utf-8

class SystemCommandFailed < RuntimeError
end

module CommandRunner
  def self.run(command)
    output = `#{command} 2>&1`
    raise SystemCommandFailed, "message" + output unless $?.success?
    output
  end
end
