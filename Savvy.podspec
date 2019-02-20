Pod::Spec.new do |s|
    s.name             = 'Savvy'
    s.version          = '0.1.0'
    s.summary          = 'Savvy API on iOS'
    s.description      = <<-DESC
    Utilize the Savvy cryptocurrency checkout API on iOS.
    DESC
    
    s.homepage         = 'https://github.com/imryan/savvy-ios.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'imryan' => 'notryancohen@gmail.com' }
    s.source           = { :git => 'https://github.com/imryan/savvy-ios.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/ryancohen'
    
    s.ios.deployment_target = '9.0'
    s.source_files = 'Savvy/Classes/**/*'
    s.dependency 'Alamofire'
end
