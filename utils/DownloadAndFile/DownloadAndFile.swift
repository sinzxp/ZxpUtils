//
//  downloadAndFile.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/3/28.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit
import Alamofire

//extension NSObject {
//    var Daf: DownloadAndFile {
//        return DownloadAndFile.share
//    }
//}

open class DownloadAndFile {
    
    ///路径有后缀要加上
    
    enum ImgSuffixType:String {
        case png = ".png"
        case jpg = ".jpg"
    }

//    static open let share = DownloadAndFile()
    
    let manager = FileManager.default
    
    ///获取户文档目录路径 Document路径
    func getUrlForDocument() -> URL {
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
//        print("urlForDocument-------->\(url)")
        return url
    }
    
    //对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
    func contentsOfURL() {
        let contentsOfURL = try? manager.contentsOfDirectory(at: getUrlForDocument(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        print("contentsOfURL: \(String(describing: contentsOfURL))")
    }
    
    ///Documents里判断文件或文件夹是否存在 isDirectory是否是文件夹
    func isFileExistsForDocuments(_ name:String ,isDirectory:ObjCBool = false) -> Bool {
        let filePath:String = NSHomeDirectory() + "/Documents/\(name)"
        var isDir: ObjCBool = isDirectory
        let exist = manager.fileExists(atPath: filePath, isDirectory: &isDir)
        return exist
    }
    
    ///保存图片到Document
    func saveImageToDocument(_ data:Data,name:String,suffixType:ImgSuffixType) {
        let imgMame = name + suffixType.rawValue
        let filePath = getUrlForDocument().appendingPathComponent(imgMame)
        print("saveImageToDocument: \(filePath)")
        if let _ =  try? data.write(to: filePath) {
            print("图片保存到Document成功")
        } else {
            print("图片保存到Document失败")
        }
    }
    
    ///保存数据到Document
    func saveDataToDocument(_ data:Data,name:String) {
        let filePath = getUrlForDocument().appendingPathComponent(name)
        print("savedateToDocument: \(filePath)")
        if let _ =  try? data.write(to: filePath) {
            print("图片到Document成功")
        } else {
            print("图片到Document失败")
        }
    }
    
    //返回data
    func readFile(_ name:String) ->Data? {
        if isFileExistsForDocuments(name) {
            let file = getUrlForDocument().appendingPathComponent(name)
            //方法1
            //let readHandler = try! FileHandle(forReadingFrom:file)
            //let data = readHandler.readDataToEndOfFile()
            //方法2
            let data = manager.contents(atPath: file.path)
            return data
        } else {
            return nil
        }
    }
    
    ///返回字符串
    func readFileForString(_ name:String) ->String? {
        if let data = readFile(name) {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
    
    ///返回字符串image
    func readFileForImage(_ name:String) ->UIImage? {
        if let data = readFile(name) {
            return UIImage(data: data)
        }
        return nil
    }
    
    ///重命名 用移动文件方法
    func renamefile(_ name:String,rename:String) -> Bool {
        let file = getUrlForDocument().appendingPathComponent(name)
        let refile = getUrlForDocument().appendingPathComponent(rename)
        if let _ = try? manager.moveItem(at: file, to: refile) {
            print("重命名成功")
            return true
        } else {
            print("重命名失败")
            return false
        }
    }
    
    ///删除文件
    func removefile(_ name:String) -> Bool {
        let file = getUrlForDocument().appendingPathComponent(name)
        if let _ = try? manager.removeItem(at: file) {
            print("删除成功")
            return true
        } else {
            print("删除失败")
            return false
        }
    }
    
    ///删除目录下所有的文件：获取所有文件，然后遍历删除
    func removeAllfile(_ directoryName:String = "" , tRouleOut:String = "") {
        let myDirectory = NSHomeDirectory() + "/Documents/\(directoryName)"
        let fileArray = manager.subpaths(atPath: myDirectory)
        for fn in fileArray!{
            if tRouleOut == fn {
                continue
            } else {
                if let _ = try? manager.removeItem(atPath: myDirectory + "/\(fn)") {
                } else {
                    print("删除失败")
                    break
                }
            }
        }
    }
    
    //MARK: Alamofire下载文件
    
    public typealias DSuccessBlock = (_ filename: String,_ destinationURL:URL,_ data:Data) -> ()
    public typealias DFailBlock = (_ error:Error,_ text:String) -> ()
    public typealias DProgressBlock = (_ progress: Double) -> ()
//    private var setDSuccess:DSuccessBlock!
//    private var setDFail:DFailBlock!
//    private var setDProgress:DProgressBlock?
    public typealias StopBlock = () -> ()

    
    private var downloadRequest: DownloadRequest! //下载请求对象
    private var cancelledData: Data? //断点下载保存数据
    private var destination:DownloadRequest.DownloadFileDestination! //下载路径
    
    /// 开始下载
    /// - parameter url:   下载路径.
    /// - parameter fileName: 文件名称 带后缀.
    /// - parameter progress:   进度0~1.
    func startDownloadUrl(_ url:String,fileName:String?,success:@escaping DSuccessBlock,fail:@escaping DFailBlock,progress:DProgressBlock?) {
//        setDSuccess = success
//        setDFail = fail
//        setDProgress = progress
        //设置下载路径。保存到用户文档目录，文件名不变，如果有同名文件则会覆盖
        destination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(fileName == nil ? response.suggestedFilename! : fileName!)") //名称
            //两个参数表示如果有同名文件则会覆盖 如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        //自带路径
//        destination = DownloadRequest.suggestedDownloadDestination()
        print("开始下载")
        let urlString = URLRequest(url: URL(string:url)!)
        downloadRequest = Alamofire.download(urlString, to: destination)
        downloadRequest.downloadProgress(queue: .main) { (progre) in
            progress?(progre.fractionCompleted)
        }
        downloadRequest.responseData { (response) in
//            let hhh =  response.response?.allHeaderFields //可以获取格式,大小
//            print("allHeaderFields2 --- \(hhh?["Content-Length"])")
            let name =  response.response?.suggestedFilename
            switch response.result {
            case .success(let data):
                success(name == nil ? "" : name! ,response.destinationURL!,data)
            case .failure(let error):
                fail(error,name == nil ? "" : name!)
                self.cancelledData = response.resumeData //意外终止的话，把已下载的数据储存起来
            }
        }
        ///可以改成这种
//        downloadRequest.downloadProgress(queue: DispatchQueue.main,closure: downloadProgress) //下载进度
//        downloadRequest.responseData(completionHandler: downloadResponse)
    }
    
    ///点击继续
    func continueDownload(success:@escaping DSuccessBlock,fail:@escaping DFailBlock,progress:DProgressBlock?) {
        print("继续下载")
        if let cancelledData = self.cancelledData {
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: destination)
            downloadRequest.downloadProgress(queue: .main) { (progre) in
                progress?(progre.fractionCompleted)
            }
            downloadRequest.responseData { (response) in
                let name =  response.response?.suggestedFilename
                switch response.result {
                case .success(let data):
                    success(name == nil ? "" : name! ,response.destinationURL!,data)
                case .failure(let error):
                    fail(error,name == nil ? "" : name!)
                    self.cancelledData = response.resumeData //意外终止的话，把已下载的数据储存起来
                }
            }
        } else {
            print("没有储存数据")
        }
    }
    
    ///点击停止
    func stopBtnClick(_ showBlock:StopBlock) {
        self.downloadRequest?.cancel()
        showBlock()
        print("停止下载")
    }
    
    //下载过程中改变进度条
//    func downloadProgress(progress: Progress) {
//        //进度条更新
//        setDProgress?(progress.fractionCompleted)
//    }
    
    //下载停止响应（不管成功或者失败）
//    func downloadResponse(response: DownloadResponse<Data>) {
//        switch response.result {
//        case .success(let data):
//            let name = response.response!.suggestedFilename!
//            setDSuccess(name,response.destinationURL!,data)
//        case .failure(let error):
//            setDFail(error)
//            self.cancelledData = response.resumeData //意外终止的话，把已下载的数据储存起来
//        }
//    }
    
    ///测试
    func testURLSession(_ url:String) {
        if let urll = URL(string: url) {
            let request = URLRequest(url: urll)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if error != nil{
                    print(error.debugDescription)
                }else{
//                    let str = String(data: data!, encoding: String.Encoding.utf8)
                    print("abcdefg ---- \(data!) --- \(response!)")
                }
            }
            //使用resume方法启动任务
            dataTask.resume()
        }
    }

}

extension String {
    /// 获取文件大小 注意返回值为UInt64类型，单位字节
    func getFileSize() -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {    // 单文件
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! UInt64
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size
    }
    
    func getFileSizeForName() -> Int {
        let ttt = NSHomeDirectory() + "/Documents/\(self)"
        return Int(ttt.getFileSize())
    }
}


