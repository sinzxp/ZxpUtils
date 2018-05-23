//
//  QPHttpUtils.swift
//  QHProject
//
//  Created by quickplain on 15/12/24.
//  Copyright © 2015年 quickplain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFNetworking
import AwesomeCache
import Qiniu

let HOST = ""

let BASE_URL = HOST + "service/"

private let URL_LOGIN = BASE_URL + "login"
private let URL_LOGOUT = BASE_URL + "logout/"

/// 预设的超时时长,2天
public let QPHttpDefaultExpires: TimeInterval = 60 * 60 * 24 * 2

/// 最大的page size
let maxPageSize = NSNumber(value: Int32.max).intValue

/// 默认page size
let pageSize = 50

open class QPHttpUtils: NSObject {

    static open let share = QPHttpUtils()

	open class func pageSize() -> Int {
		return 100
	}

	/**
     是否连接WiFi,有待详尽测试
     
     - returns:
     */
	public class func isWifi() -> Bool {
		let host = "www.baidu.com"
		if let manager = NetworkReachabilityManager(host: host) {
			return manager.isReachableOnEthernetOrWiFi
		} else {
			return false
		}
	}
    
    public class func isConnecting() -> Bool {
        let host = "www.baidu.com"
        if let manager = NetworkReachabilityManager(host: host) {
            return manager.isReachable
        } else {
            return false
        }
    }
    
	var sessionKey = ""
    var timeGap:TimeInterval = 0
    

//	let manager = Alamofire.Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let manager = Alamofire.SessionManager.default


//	public func download(url: String, block: (image: UIImage) -> ()) {
//		Alamofire.request(.POST, url, parameters: [:]).responseData { response in
//			if let data = response.result.value {
//				if let image = UIImage(data: data) {
//					block(image: image)
//				}
//			}
//		}
//	}

	 

	private func mgr() -> SessionManager {

//		let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.example.app.background")
//  		let manager = Alamofire.Manager(configuration: configuration)
//  		return manager
        return Alamofire.SessionManager.default
	}

	private let QPHttpCacheName = "QPCache"

//    var httpManager = AFHTTPRequestOperationManager()

//	public class var sharedInstance: QPHttpUtils {
//		struct Static {
//			static var onceToken: dispatch_once_t = 0
//			static var instance: QPHttpUtils? = nil
//		}
//		dispatch_once(&Static.onceToken) {
//			Static.instance = QPHttpUtils()
//		}
//		return Static.instance!
//	}

	public typealias QPSuccessBlock = (_ response: JSON) -> ()
	public typealias QPFailBlock = () -> ()

	public typealias QPOldSuccessBlock = (_ response: AnyObject?) -> ()

	open class func request(url: String, param: [String: AnyObject]!, success: QPSuccessBlock!, fail: QPFailBlock!) -> () {
//		return QPHttpUtils.sharedInstance.newHttpRequest(url, param: param, success: success, fail: fail)
	}

//	override init() {
//		super.init()
//		cleanHttpCache()
//	}

	 
	/**
	 从http缓存获取JSON

	 - parameter key: 缓存的key

	 - returns: JSON
	 */
//	public func responseFromCache(key: String) -> JSON? {
//		do {
//			let cache = try Cache<NSString>(name: QPHttpCacheName)
//			if let cacheResult = cache.objectForKey(key) as? String {
//				let json = JSON.parse(cacheResult)
//				return json
//			}
//		} catch _ {
//			log.warning("Something went wrong when responseFromCache :(")
//		}
//		return nil
//	}

	/**
	 将JSON缓存

	 - parameter response: 服务器返回的JSON
	 - parameter key:      缓存key
	 - parameter expires:  超时时长,默认0
	 */
//	public func cacheResponse(response: JSON, key: String, expires: NSTimeInterval = 0) {
//
//		do {
//			let cache = try Cache<NSString>(name: QPHttpCacheName)
//			let value = response.toJSONString()
//			cache.setObject(value, forKey: key, expires: .Seconds(expires))
//		} catch _ {
//			log.warning("Something went wrong when cacheResponse :(")
//		}
//	}

	/**
	 清除所有http缓存
	 */
	open func clearHttpCache() {
		do {
			let cache = try Cache<NSString>(name: QPHttpCacheName)
			cache.removeAllObjects()
		} catch _ {
//			log.warning("Something went wrong when clearHttpCache :(")
		}
	}

	/**
	 清除超时http缓存

	 - parameter key: 要清除的key的缓存
	 */
//	public func cleanHttpCache(key: String? = nil) {
//		do {
//			let cache = try Cache<NSString>(name: QPHttpCacheName)
//			cache.removeExpiredObjects()
//			if let key = key {
//				cache.removeObjectForKey(key)
//			}
//		} catch _ {
//			log.warning("Something went wrong when cleanHttpCache :(")
//		}
//	}

	public func coreOperation(url: String, param: [String: AnyObject]!, expires: TimeInterval = 0, success: QPSuccessBlock!, fail: QPFailBlock!) {
	}
	/**
	 新的http方法,推荐使用

	 - parameter url:     url
	 - parameter param:   参数
	 - parameter expires: 超时时长,默认0s.若expires=0,立即访问服务器.否则根据expires决定从服务器还是缓存返回结果
	 - parameter success: 成功 JSON
	 - parameter fail:    失败
	 */
	open func httpRequest(url: String, param: Parameters?, expires: TimeInterval = 0, success: QPSuccessBlock!, fail: QPFailBlock!) -> () {
 
        var newParam = param == nil ? [:] : param!
        newParam["version"] = "\(AppInfoManager.getVersion()!)"
        newParam["build"] = "\(AppInfoManager.getBuild()!)"
        newParam["timestamp"] = Int(Date().timeIntervalSince1970 * 1000)

        let mgr  = self.mgr()
        let request = mgr.request(url, method: HTTPMethod.post, parameters: newParam, encoding: URLEncoding.default, headers: nil).responseString { (response) in
//            let datastring = String(data: response.data!, encoding: String.Encoding.utf8)
//            print("****************\n\(response.result.value)\n--------------\n\(url)\n*************\n\(datastring)\n***************")
            if let value = response.result.value {
                let json = JSON(parseJSON: value)
                if json == nil {
                    success(JSON(value))
                    return
                }
                success(json)
            }else{
                print("\(response.result.value)")
                fail()
            }
        }
        print("-----------\n\(request)\n--------------")
	}

	/**
	 上传图片

	 - parameter url:    上传地址
	 - parameter param:  附带的参数
	 - parameter images: 图片的列表
	 - parameter names:  图片名称的列表
	 - parameter succes: 成功返回JSON
	 - parameter fail:   失败
	 */
	func uploadFile( url: String, param: [String: AnyObject], images: Array<UIImage>, names: Array<String>, succes: QPSuccessBlock, fail: QPFailBlock) {

//		let URL = NSURL(string: url)
//		let mutableURLRequest = NSMutableURLRequest(URL: URL!)
//		let paramUrl = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: param).0.URLString
//
//		Alamofire.upload(.POST, paramUrl, multipartFormData: { (multipartFormData) -> Void in
//			for image in images {
//				let index = images.indexOf(image)!
//				let name = names[index]
//				let dataObj = UIImageJPEGRepresentation(image, 1.0)!
//				multipartFormData.appendBodyPart(data: dataObj, name: name, fileName: "\(name).png", mimeType: "multipart/form-data")
//			}
//			}, encodingCompletion: { (encodingResult) -> Void in
//			switch encodingResult {
//			case .Success(let upload, _, _):
//				upload.responseJSON { response in
//					debugPrint(response)
////                    response.result.
//				}.progress({ (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
////					print("\(bytesWritten) \(totalBytesWritten) \(totalBytesExpectedToWrite)")
//				})
//			case .Failure(let encodingError):
//				print(encodingError)
//			}
//		})
        
        
	}

	/**
     上传图片到第三方服务器,免费
     {
     "size" : 12807,
     "delete" : "https:\/\/sm.ms\/api\/delete\/Az42EU83HRWFyiL",
     "width" : 75,
     "ip" : "61.143.46.255",
     "filename" : "smfile.png",
     "height" : 75,
     "timestamp" : 1479376460,
     "path" : "\/2016\/11\/17\/582d7e4c4309b.png",
     "hash" : "Az42EU83HRWFyiL",
     "url" : "http:\/\/ooo.0o0.ooo\/2016\/11\/17\/582d7e4c4309b.png",
     "storename" : "582d7e4c4309b.png"
     }
     
     let url = response["data"]["url"]

     - parameter image:   图片文件
     - parameter success: success description
     - parameter fail:    fail description
     */
//	public func uploadThirdPartImage(image: UIImage, success: QPSuccessBlock!, fail: QPFailBlock!) {
//		let url = "https://sm.ms/api/upload"
//		if let URL = NSURL(string: url) {
//			let mutableURLRequest = NSMutableURLRequest(URL: URL)
//			mutableURLRequest.HTTPMethod = "POST"
//			Alamofire.URLRequestConvertible
//
//			manager.upload(mutableURLRequest, multipartFormData: { (multipartFormData) in
//				let dataObj = UIImageJPEGRepresentation(image, 1.0)!
//				let name = "smfile"
//				multipartFormData.appendBodyPart(data: dataObj, name: name, fileName: "\(name).png", mimeType: "multipart/form-data")
//
//				let desc = "{\"format\":\"json\",\"ssl\":false}";
//				let descData = desc.dataUsingEncoding(NSUTF8StringEncoding)!
//				multipartFormData.appendBodyPart(data: descData, name: "description", mimeType: "text/plain")
//
//				}, encodingCompletion: { encodingResult in
//				switch encodingResult {
//				case .Success(let upload, _, _):
//					upload.responseJSON { response in
//						let datastring = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
//						if let value = datastring as? String {
//							let json = JSON.parse(value)
//							if json == nil {
//								let json = JSON(value)
//								success(response: json)
//								return
//							}
//							success(response: json)
//							return
//						} else if let value = response.result.value as? String {
//							let json = JSON.parse(value)
//							success(response: json)
//							return
//						} else {
//							fail()
//							return
//						}
//					}
//				case .Failure(let encodingError):
//					print(encodingError)
//					log.error("encodingError \(encodingError)")
//					fail()
//				}
//			})
//			// manager.request(.POST, url, parameters: param)
////			manager.upload(encodedURLRequest, multipartFormData: { (multipartFormData) -> Void in
////				let dataObj = UIImageJPEGRepresentation(image, 1.0)!
////				let name = imageName[iii]
////				multipartFormData.appendBodyPart(data: dataObj, name: name, fileName: "\(name).png", mimeType: "multipart/form-data")
//////                multipartFormData.
////				}, encodingCompletion: { encodingResult in
////				switch encodingResult {
////				case .Success(let upload, _, _):
////					upload.responseJSON { response in
////						let datastring = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
////						if let value = datastring as? String {
////							let json = JSON.parse(value)
////							if json == nil {
////								let json = JSON(value)
////								success(response: json)
////								return
////							}
////							success(response: json)
////							return
////						} else if let value = response.result.value as? String {
////							let json = JSON.parse(value)
////							success(response: json)
////							return
////						} else {
////							fail()
////							return
////						}
////					}
////				case .Failure(let encodingError):
////					print(encodingError)
////					log.error("encodingError \(encodingError)")
////					fail()
////				}
////			})
//		} else {
//			fail()
//		}
//	}

	open func uploadImage(url: String, param: [String: Any]?, imageName: [String], images: [UIImage], success: QPSuccessBlock!, fail: QPFailBlock!) {
        
        let mgr  = self.mgr()
//        let ss = mgr.session
        let urll = URL(string: url)!
        let urlRequest = URLRequest(url: urll)
        let paramUrl = try? URLEncoding.default.encode(urlRequest , with: param)
        if var paramUrl = paramUrl {
            paramUrl.httpMethod = "POST"
            mgr.upload(multipartFormData: { multipartFormData in
                for image in images {
                    let index = images.index(of: image)!
                    let name = imageName[index]
                    let dataObj = UIImageJPEGRepresentation(image, 1.0)!
                    multipartFormData.append(dataObj, withName: name, fileName: "asd.jpg", mimeType: "multipart/form-data")
                    print("upload name \(name)")
                }
            }, with: paramUrl, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let datastring = String(data: response.data!, encoding: String.Encoding.utf8)
                        if let value = datastring  {
                            let json = JSON(parseJSON: value)
                            print("value1___\(json)")
                            if json == nil {
                                let json = JSON(value)
                                print("value1.1___\(json)")
                                success(json)
                                return
                            }
                            success(json)
                            return
                        } else if let value = response.result.value as? String {
                            let json = JSON(parseJSON:value)
                            print("value2___\(json)")
                            success(json)
                            return
                        } else {
                            fail()
                            return
                        }
                    }
                case .failure(let encodingError):
                    print("encodingError_________>\(encodingError)")
                    fail()
                }
            })
        } else {
            print("GGGGGGGGGGG")
            fail()
        }
        //[[[[[[[[[[[[[[[[[[[[3.2 不带param
//        mgr.upload(
//            multipartFormData: { multipartFormData in
//                for image in images {
//                    let index = images.index(of: image)!
//                    let name = imageName[index]
//                    let dataObj = UIImageJPEGRepresentation(image, 1.0)!
////                    let dataObj = UIImagePNGRepresentation(image)!
////                    let imageData = uipng
////                    multipartFormData.append(dataObj, withName: name)
//                    multipartFormData.append(dataObj, withName: name, fileName: "asd.jpg", mimeType: "multipart/form-data")
//                    print("upload name \(name)")
////                    multipartFormData.append(dataObj, withName: name, mimeType: "image/jpeg")
//                }
//        },
//            to: url,
//            encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
////                        debugPrint(response)
//                        print("response \(response)")
//
//                        let datastring = String(data: response.data!, encoding: String.Encoding.utf8)
//                        print("datastring \(datastring)")
//
//                        if let value = datastring  {
//                            print("value \(value)")
//                            let json = JSON.parse(value)
//                            if json == nil {
//                                let json = JSON(value)
//                                success( json)
//
//                                return
//                            }
//                            success(json)
//                            return
//                        } else if let value = response.result.value as? String {
//                            let json = JSON.parse(value)
//                            success(json)
//                            return
//                        } else {
//                            fail()
//                            return
//                        }
//
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                    fail()
//                }
//        }
//        )
        ////////]]]]]]3.2
	}

//    private func newHttpRequet(url: String, param: [NSObject : AnyObject]!, success: CJWSuccessBlock!, fail: CJWFailBlock!){
////        CJWNetworkActivityIndicator.startIndicator()
//        print("url \(url) param \(param)")
//        httpManager.POST(url, parameters: param, success: { (operation, responseObject) -> Void in
//            CJWNetworkActivityIndicator.stopIndicator   ()
//            success(responseObject)
//            }) { (operation, error) -> Void in
//                CJWNetworkActivityIndicator.stopIndicator()
//                if let statusCode = operation!.response?.statusCode {
//                    if statusCode == 200 {
//                        success(operation!.responseString)
//                        return
//                    }
//                }
//                print("url:\(url)\n\(error) \(operation!.responseString)")
//                fail()
//        }
//
//    }
//    func requestUrlWithCache(url: String!, param: [NSObject : AnyObject]!, success: CJWSuccessBlock!, failure: CJWFailBlock!){
//        let key = "\(url)-\(param)"
//        var compare : AnyObject = ""
//        if let result = QPCacheUtils.getCacheBy(key) {
//            compare = result
//            success(result)
//        }else{
//            print("object from cache fail \(key)")
//        }
//        requestUrl(url, param: param, success: { (resp) -> Void in
//            if compare.isEqual(resp){
//            }else{
//                success(resp)
//                QPCacheUtils.cache(resp, forKey: key, toDisk: true)
//            }
//
//            }) { () -> Void in
//                failure()
//        }
//    }
//
//    func requestUrl(url: String!, param: [NSObject : AnyObject]!, success: CJWSuccessBlock!, fail: CJWFailBlock!) {
//        var newParam = addAuth(param)
//        if url == URL_LOGIN {
//            newParam = param
//        }
//        //        self.newHttpRequet(url, param: newParam, success: success, fail: fail)
//        self.newHttpRequet(url, param: newParam, success: { (resp) -> Void in
//            if let result = resp as? NSDictionary {
//                if let error = result["error"] as? String {
//                    print("error \(error)")
//                    if error == "logout" {
//                        //                        AppDelegate.toHome()
//                        NSNotificationCenter.defaultCenter().postNotificationName("GoLogin", object: nil)
//                        UIApplication.shared.keyWindow?.rootViewController?.view.showTemporary(text: "您的账号已在别处登录")
//                        fail()
//                        return
//                    }else if error == "nologin" {
////                        self.http.login({ () -> () in
////                            self.newHttpRequet(url, param: self.addAuth(param), success: { (reps) -> Void in
////                                success(resp)
////                                }, fail: { () -> Void in
////                                    fail()
////                            })
////                            }, loginFailBlock: { (text) -> () in
////                                fail()
////                            }, failure: { () -> Void in
////                                fail()
////                        })
//                        return
//                    }
//                }
//            }
//            success(resp)
//            }) { () -> Void in
//                fail()
//        }
//
//    }
//
//    private func pushId() -> String{
//        return QPPushUtils.getPushID()
//    }
//
//    func addAuth(param: [NSObject : AnyObject]!) -> [NSObject : AnyObject]!{
//        if param == nil {
//            return param
//        }else{
//            let newParam = NSMutableDictionary(dictionary: param as NSDictionary)
//            if QPMemberUtils.sharedInstance.memberId != -1 {
//                let uid = QPMemberUtils.sharedInstance.memberId
//                let session = QPHttpUtils.sharedInstance.sessionKey
//                let str = "\(uid)-\(pushId())"
//                let auth = CJWDesEncrypt.encrypt(str, key: session)
//                print("\(str) \(auth) \(session)")
//                newParam.setValue(auth, forKey: "auth")
//                return newParam as [NSObject : AnyObject]
//            }
//            return newParam as [NSObject : AnyObject]
//        }
//    }
}

// MARK: - 身份证识别
public extension QPHttpUtils {
	/**
     身份证识别
     
     - parameter imageUrl: 身份证url
     - parameter success:  success description
     - parameter failure:  failure description
     */
	public class func IDCardRecongizeFromUrl(imageUrl: String, success: QPSuccessBlock, failure: QPFailBlock) {
        assertionFailure("IDCardRecongizeFromUrl")
//		let url = "https://api.megvii.com/cardpp/v1/ocridcard"
//		let param = ["api_key": "4KIL18K6lUgz3YZdZtBcwUuedBudMJE4", "api_secret": "2Gdg9sMUo3aUNytMPbshWsnsrxIDEf2M", "image_url": imageUrl]
//		QPHttpUtils.sharedInstance.newHttpRequest(url, param: param, success: { (response) in
//			success(response: response)
//		}) {
//			failure()
//		}
	}

	/**
     身份证识别
     
     - parameter image:   身份证图片文件
     - parameter success: success description
     - parameter failure: failure description
     */
	public class func IDCardRecongize(image: UIImage, success: QPSuccessBlock, failure: QPFailBlock) {
        assertionFailure("IDCardRecongize")

//		let url = "http://web.cenjiawen.com/qp/cardRecg"
//		QPHttpUtils.sharedInstance.uploadImage(url, param: nil, imageName: ["image_file"], images: [image], success: { (response) in
//			success(response: response)
//		}) {
//			failure()
//		}
	}
}

public extension QPHttpUtils {

	/**
     上传图片
     
     - parameter image:   图片nsdata
     - parameter path:    图片路径
     - parameter baseUrl: 图片url前缀
     - parameter token:   七牛
     - parameter success: success description
     - parameter failure: failure description
     */
	public func uploadImage(image: UIImage, path: String, baseUrl: String, token: String, success: @escaping QPSuccessBlock, failure: @escaping QPFailBlock) {
//        if let imageData = UIImagePNGRepresentation(image) {
        if let imageData = UIImageJPEGRepresentation(image, 1) {//更小
			uploadFile(data: imageData, path: path, baseUrl: baseUrl, token: token, success: success, failure: failure)
		} else {
			failure()
		}
	}

	/**
     七牛上传图片
     
     - parameter data:    文件nsdata
     - parameter path:    文件路径 如CJWUtilsS
     - parameter baseUrl: 文件url cdn路径 如http://img.moo-mi.com/
     - parameter token:   token
     - parameter success: success description
     - parameter failure: failure description
     */
	public func uploadFile(data: Data, path: String, baseUrl: String, token: String, success: @escaping QPSuccessBlock, failure: @escaping QPFailBlock) {
		let upManager = QNUploadManager()
		let uuid: String = NSUUID.init().uuidString
		let key = "\(path)/\(uuid)"
		let imageUrl = "\(baseUrl)\(key)"
		upManager?.put(data, key: key, token: token, complete: { (info, key, resp) -> Void in
            print("七牛 ---> \(String(describing: info))")
			if (info?.statusCode == 200 && resp != nil) {
//				self.newHttpRequest("http://qp.cenjiawen.com:9090/image", param: ["img": "\(imageUrl)"], success: { (response) in
//					}, fail: {
//				})
				success(JSON(imageUrl))
			} else {
//				log.error("七牛上传失败")
//				log.error("\(info)")
				failure()
			}
			}, option: nil)
	}

	/**
     上传到cjw七牛服务器
     
     - parameter image:   图片nsdata
     - parameter path:    路径
     - parameter success: success description
     - parameter failure: failure description
     */
	public func uploadCJWImage(image: UIImage, path: String, success: @escaping QPSuccessBlock, failure: @escaping QPFailBlock) {
		QPHttpUtils.share.httpRequest(url: "http://app.cenjiawen.com/qntoken/1", param: nil, success: { (response) in
			if let token = response["info"].string {
//                let cfg = QNConfiguration.build { (builder) in
//                    builder?.setZone(QNZone.zone1())
//                }
                let cfg = QNConfiguration.build({ (builder) in
                    builder?.setZone(QNFixedZone.zone1())
                })
				let baseUrl = "http://pic.cenjiawen.com/"
				let upManager = QNUploadManager(configuration: cfg)
				let uuid: String = NSUUID.init().uuidString
				let key = "\(path)/\(uuid)"
				let imageUrl = "\(baseUrl)\(key)"
				if let imageData = UIImagePNGRepresentation(image) {
					upManager?.put(imageData, key: key, token: token, complete: { (info, key, resp) -> Void in
						if (info?.statusCode == 200 && resp != nil) {
							success(JSON(imageUrl))
						} else {
//							log.error("七牛上传失败")
//							log.error("\(info)")
							failure()
						}
						}, option: nil)
				} else {
				}
			} else {
				failure()
			}
		}) {
			failure()
		}
	}

	private func getBundleId() -> String {
		if let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
			return bundleId
		} else {
			return "CJWUtilsS"
		}
	}

	public func uploadImageCompress(image: UIImage, path: String = "", success: @escaping QPSuccessBlock, failure: @escaping QPFailBlock) {
		uploadImage(image: image.compress(), path: path, success: success, failure: failure)
	}
	/**
     默认上传到谢文俊的七牛
     
     - parameter image:   图片UIImage
     - parameter path:    路径,默认CJWUtilsS
     - parameter success: success description
     - parameter failure: failure description
     */
	public func uploadImage(image: UIImage, path: String = "", success: @escaping QPSuccessBlock, failure: @escaping QPFailBlock) {
		var ppp = path
		if ppp == "" {
			ppp = getBundleId()
//			ppp = ppp.encryptAES("IX07L2433M88JCJW") ?? getBundleId()
			ppp.urlEncode()
		}
		QPHttpUtils.share.httpRequest(url: "http://app.cenjiawen.com/qntoken/", param: nil, success: { (response) in
            print(response)
			if let token = response["info"].string {
//				let tmpImg = UIImage.scaleImage(image, toSize: CGSizeMake(200, 200))
                self.uploadImage(image: image, path: ppp, baseUrl: "http://img.moo-mi.com/", token: "\(token)", success: { (JSON) in
                    success(JSON)
                }, failure: { 
                    failure()
                })
			} else {
				failure()
			}
		}) {
			failure()
		}
	}
}
