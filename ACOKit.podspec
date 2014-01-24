
Pod::Spec.new do |s|
  
  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.name         = "ACOKit"
  s.version      = "0.1.0"
  s.summary      = "An Objective-C library for handling Adobe Color Swatch files in the ACO format."
  
  s.description  = <<-DESC
                   ACOKit reads Adobe Color Swatch files and makes the colors
                   available as UIColor/NSColor for your application.
                   DESC
  
  s.homepage     = "https://github.com/frenetisch-applaudierend/acokit"
  
  
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  
  
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.author             = { "Markus Gasser" => "markus.gasser@konoma.ch" }
  
  
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  
  
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.source       = { :git => "https://github.com/frenetisch-applaudierend/acokit.git", :tag => "0.1.0" }
  
  
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.source_files  = 'Sources/**/*.{h,m}'
  s.ios.exclude_files = 'Sources/**/*+AppKit.{h,m}'
  s.osx.exclude_files = 'Sources/**/*+UIKit.{h,m}'
  s.public_header_files = 'Sources/**/*.h'
  
  
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.osx.frameworks = 'Cocoa'
  
  
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.requires_arc = true
  
end
