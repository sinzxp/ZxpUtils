Pod::Spec.new do |s|

  s.name     = 'ZxpUtils' 
  s.version  = '0.0.1' 
  s.license  = 'MIT'
  #主要标题
  s.summary  = 'All sorts of things'
  #详细描述（必须大于主要标题的长度）
  s.description  = <<-DESC
        	随便写的一些工具 哈哈哈哈哈哈哈哈哈哈哈
                   DESC
  #仓库主页
  s.homepage = 'https://github.com/sinzxp/ZxpUtils'
  s.author   = { 'zxp' => '1107765052@qq.com' }
  #s.social_media_url   = 'http://weibo.com/'
  s.platform = :ios, '9.0'
  #仓库地址（注意下tag号）
  s.source   = { :git => 'https://github.com/sinzxp/ZxpUtils.git', :tag => s.version.to_s }

  s.requires_arc = true
  #这里路径必须正确 ,号隔开
  s.source_files = 'utils/*.*','ZxpUtils/ZxpUtils-Bridging-Header.h','utils/DownloadAndFile/*.*','utils/PopupWindow/*.*','utils/ZXPPhotoPicker/*.*','utils/View/*.*','utils/VarietyViewController/*.*','utils/QP/Utils/*.*','utils/QP/UI/*.*','utils/QP/Lib/**/*.*'

#  s.resources = "Resources/*.png"

  #系统库
  s.frameworks = 'UIKit'

  #其他库
  s.dependency 'Alamofire','4.7.0'
  s.dependency 'AFNetworking'
#    pod 'AsyncSwift' -
  s.dependency 'AwesomeCache'
#    pod 'Bugly' -
  s.dependency 'CryptoSwift','0.7.0'
  s.dependency 'CGFloatType'
  s.dependency 'ClusterPrePermissions'
  s.dependency 'DZNEmptyDataSet'
#    pod 'FXBlurView'
  s.dependency 'FlatUIKit'
#    pod 'FMDB'
  s.dependency 'FLKAutoLayout'
  s.dependency 'FCFileManager'
  s.dependency 'GPUImage'
#    pod 'HappyDNS'
  s.dependency 'HMSegmentedControl'
#    pod 'iCarousel'
  s.dependency 'iVersion'
  s.dependency 'iRate'
  s.dependency 'INTULocationManager'
  s.dependency 'JXBAdPageView'
  s.dependency 'KLCPopup'
  s.dependency 'LKDBHelper'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'
#    pod 'MLeaksFinder'
#    pod 'Masonry'
  s.dependency 'NSDate+TimeAgo'
#    pod 'ObjcExceptionBridging'
  s.dependency 'PodAsset'
#    pod 'PhoneNumberKit','1.2.3' -
#    pod 'QRCodeReaderViewController'
  s.dependency 'Qiniu'
  s.dependency 'SDWebImage'
  s.dependency 'SnapKit','3.2.0'
  s.dependency 'SwiftyJSON'
  s.dependency 'SVProgressHUD'
#    pod 'SAMKeychain'
#    pod 'SSKeychain' -
#    pod 'WebViewJavascriptBridge'
#    pod 'YYModel'
  s.dependency 'XCGLogger','5.0.1'

end