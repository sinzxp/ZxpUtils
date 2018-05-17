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
    
    ///Documents里判断文件或文件夹是否存在
    func isFileExistsForDocuments(_ name:String) -> Bool {
        let filePath:String = NSHomeDirectory() + "/Documents/\(name)"
        let exist = manager.fileExists(atPath: filePath)
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
    func removeAllfile(_ directoryName:String = "") {
        let myDirectory = NSHomeDirectory() + "/Documents/\(directoryName)"
        let fileArray = manager.subpaths(atPath: myDirectory)
        for fn in fileArray!{
            if let _ = try? manager.removeItem(atPath: myDirectory + "/\(fn)") {
            } else {
                print("删除失败")
                break
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
            //            print("response.suggestedFilename!--------->\(response.suggestedFilename!)")
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
            switch response.result {
            case .success(let data):
                let name = response.response!.suggestedFilename!
                success(name,response.destinationURL!,data)
            case .failure(let error):
                fail(error,"0")
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
                switch response.result {
                case .success(let data):
                    let name = response.response!.suggestedFilename!
                    success(name,response.destinationURL!,data)
                case .failure(let error):
                    fail(error,"1")
                    self.cancelledData = response.resumeData //意外终止的话，把已下载的数据储存起来
                }
            }
        } else {
            print("没有储存数据")
        }
    }
    
    ///点击停止
    func stopBtnClick() {
        self.downloadRequest?.cancel()
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

}


extension DownloadAndFile {
    
}

