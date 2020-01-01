#
# Be sure to run `pod lib lint PzKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PzKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PzKit.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/sawrysc@163.com/PzKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sawrysc@163.com' => 'jiarui.li@carrobot.com' }
  s.source           = { :git => 'https://github.com/sawrysc@163.com/PzKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '8.0'
  
  
  s.default_subspec = 'Crash'
  
  s.subspec 'Crash' do |ss|
    ss.source_files = 'PzKit/Classes/Srouce/Crash/**/*'
    ###ss.vendored_frameworks = 'DoraemonKit/Lib/CrashReporter.framework'
    ss.resource_bundles = {
      'PzKit' => 'PzKit/Classes/Resource/**/*'
    }
  end
  
  
  s.subspec 'Monitor' do |ss|
    ss.source_files = 'PzKit/Classes/Srouce/Monitor/**/*'
    #    ss.pod_target_xcconfig = {
    
    #    }
    #    ss.dependency 'AFNetworking'
  end
  
  
  s.dependency 'BSBacktraceLogger'
  
  
  # s.resource_bundles = {
  #   'PzKit' => ['PzKit/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
