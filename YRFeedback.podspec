

Pod::Spec.new do |spec|

  spec.name         = "YRFeedback"
  spec.version      = "1.0.0"
  spec.summary      = "盈软反馈组件"
  spec.description  = <<-DESC
	用于tapd、tracup等平台反馈
	DESC
  spec.homepage     = "https://github.com/CCYSmile/YRFeedback"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "CCYSmile" => "cuiChangYunSmile@icloud.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/CCYSmile/YRFeedback.git", :tag => "#{spec.version}" }
  spec.source_files  = "YRFeedback/**/*.{h,m}"
  spec.resource     = 'YRFeedback/Feedback/YRFeedback.bundle'
  spec.dependency "QMUIKit", "~> 4.0.4"
  spec.dependency "NerdyUI"
  spec.dependency "AFNetworking"
  spec.dependency "Qiniu", "~> 7.3"

end
