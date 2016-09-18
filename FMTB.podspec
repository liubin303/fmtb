Pod::Spec.new do |s|
  s.name             = 'FMTB'
  s.version          = '0.1.0'
  s.summary          = 'A Objective-C wrapper around UITableView'
  s.description      = <<-DESC
 fast build and manager a tableView.
                       DESC

  s.homepage         = 'https://github.com/liubin303/fmtb'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liubin303' => '273631976@qq.com' }
  s.source           = { :git => 'https://github.com/liubin303/fmtb.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.source_files = 'FMTB/Classes/**/*'
  s.resource_bundles = {
    'FMTB' => ['FMTB/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true
  s.dependency "MJRefresh" , "~> 2.3.2"
  s.dependency "Masonry" , "~> 0.6.2"

end