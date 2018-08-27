#
# Be sure to run `pod lib lint YTTCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YTTCache'
  s.version          = '0.1.1'
  s.summary          = '简单数据缓存.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    简单数据缓存.采用键值对存储,用于网络请求缓存.
                       DESC

  s.homepage         = 'https://github.com/AndyCuiYTT/YTTCache'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AndyCuiYTT' => 'AndyCuiYTT@163.com' }
  s.source           = { :git => 'https://github.com/AndyCuiYTT/YTTCache.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YTTCache/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YTTCache' => ['YTTCache/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SQLite.swift', '~> 0.11.5'
end
