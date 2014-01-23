Pod::Spec.new do |s|
  s.name         = "Mocka"
  s.version      = "0.6.1"
  s.summary      = "Mocka is an Objective-C mocking library designed after mockito."
  s.description  = <<-DESC
                   Mocka is an Objective-C mocking library designed after mockito.
                   The goal is to provide a powerful yet simple and readable way to
                   isolate your objects and testing messages between objects.
                   
                   Features include:
                   * Use first, verify later – Use a natural flow when mocking
                     and verifying interaction
                   * Readable syntax - Mocka syntax is focused on being readable
                     and understandable, even if you never used it before.
                   * Easy to refactor - Mocka makes Xcode’s life as easy as possible
                     when it comes to refactoring, particularly renaming methods
                   * Support for spies - Spy method invocations on existing objects
                   * Mock network calls - If you have the OHHTTPStubs library
                     available you can use mocka syntax to verify network calls
                   DESC
  s.homepage     = "https://bitbucket.org/foensi/mocka"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Markus Gasser" => "markus.gasser@konoma.ch" }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "git@bitbucket.org:foensi/mocka.git", :tag => "0.6.1" }
  s.source_files = 'Sources'
  s.frameworks = 'Foundation', 'XCTest'
  s.requires_arc = true
end
