//
//  URLSessionDownloadViewController.swift
//  URLSessionDownloadDemo
//
//  Created by FancyLou on 2019/2/22.
//  Copyright © 2019 O2OA. All rights reserved.
//

import UIKit





class URLSessionDownloadViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    private var responseData: Data? = nil
    private var session: URLSession? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "URLSession下载Demo"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.session?.invalidateAndCancel()
        self.session = nil
        self.responseData = nil
    }
    
    @IBAction func download(_ sender: UIButton) {
        let url = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550849217145&di=fe0f31c4158338967ce7fd3ab13f2b7c&imgtype=0&src=http%3A%2F%2Fwww.himitukiti.jp%2Fhot%2Fftp-box%2Fimg20150501233536.jpg"
        guard self.session == nil else {
            print("正在下载。。。。")
            return
        }
        //创建请求
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        //不需要缓存
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        // session会话
        let config = URLSessionConfiguration.default
        
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        // 创建下载任务
        let downloadTask = session?.dataTask(with: urlRequest)
        // 开始下载
        downloadTask?.resume()
    }
    
    private func refreshUI(progress: Float, error: Error?) {
        self.progressView?.setProgress(progress, animated: true)
        print("进度1：\(progress)")
        if error == nil, self.responseData != nil {
            self.imageView?.image = UIImage(data: self.responseData!)
        }else {
            print("error1:\(String(describing: error))")
        }
    }
}


extension URLSessionDownloadViewController: URLSessionDataDelegate {
    
    // 接收到服务器响应的时候调用该方法 completionHandler .allow 继续接收数据
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("开始响应...............")
        completionHandler(.allow)
    }
    
    //接收到数据 可能调用多次
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("接收到数据...............")
        if self.responseData == nil {
            self.responseData = Data.init()
        }
        self.responseData?.append(data)
        let currentLength = Float(self.responseData?.count ?? 0)
        // 这里有个问题 有些自己做的数据返回 header里面没有length 那就无法计算进度
        let totalLength = Float(dataTask.response?.expectedContentLength ?? 1)
        var progress = currentLength / totalLength
        if totalLength<0 {
            progress = 0.0
        }
        print("current: \(currentLength) , total:\(totalLength), progress:\(progress)")
        weak var downloadSelf = self
        DispatchQueue.main.async {
            downloadSelf?.refreshUI(progress: progress, error: nil)
        }
    }
    //下载结束 error有值表示失败
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("下载完成")
        weak var downloadSelf = self
        DispatchQueue.main.async {
            downloadSelf?.refreshUI(progress: 1.0, error: error)
            downloadSelf?.session?.invalidateAndCancel()
            downloadSelf?.session = nil
            downloadSelf?.responseData  = nil
        }
    }
}
