//
//  URLSessionDownloadViewController.swift
//  URLSessionDownloadDemo
//
//  Created by FancyLou on 2019/2/22.
//  Copyright © 2019 O2OA. All rights reserved.
//

import UIKit





class URLSessionDownloadViewController: UIViewController {
    
    var progressView1: UIProgressView?
    var imageView1: UIImageView?
    
    
    
    private var responseData: Data? = nil
    private var session: URLSession? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "URLSession下载Demo"
        // 进度条
        self.progressView1 = UIProgressView(progressViewStyle: .default)
        let y = self.navigationController?.navigationBar.frame.height ?? 44
        //刘海屏要加44
        self.progressView1?.frame = CGRect(x: 0, y: y + 44, width: SCREEN_WIDTH, height: 2)
        self.progressView1?.progressTintColor = UIColor.red
        self.progressView1?.trackTintColor = UIColor.black
        self.view.addSubview(self.progressView1!)
        // 开始按钮
        let downLoadBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - 100)/2.0, y: 164, width: 100, height: 40))
        downLoadBtn .setTitle("开始下载", for: .normal)
        downLoadBtn .addTarget(self, action: #selector(beginDownload), for: .touchUpInside)
        downLoadBtn.backgroundColor = UIColor.gray
        self.view.addSubview(downLoadBtn)
        imageView1 = UIImageView(frame: CGRect(x: (SCREEN_WIDTH - 200)/2.0, y: 224, width: 200, height: 200))
        self.view.addSubview(imageView1!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.session?.invalidateAndCancel()
        self.session = nil
        self.responseData = nil
    }
    
    @objc func beginDownload()  {
        let url = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550815082617&di=b1d5d17090ce541bd8e076efaf4a8eec&imgtype=0&src=http%3A%2F%2Fy0.ifengimg.com%2Fifengimcp%2Fpic%2F20140822%2Fd69e0188b714ee789e97_size87_w800_h1227.jpg"
        download(url)
    }
    
    
    private func download(_ url: String) {
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
    
    private func freshUI(progress: Float, error: Error?) {
        self.progressView1?.setProgress(progress, animated: true)
        print("进度1：\(progress)")
        if error == nil, self.responseData != nil {
            self.imageView1?.image = UIImage(data: self.responseData!)
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
            downloadSelf?.freshUI(progress: progress, error: nil)
        }
    }
    //下载结束 error有值表示失败
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("下载完成")
        weak var downloadSelf = self
        DispatchQueue.main.async {
            downloadSelf?.freshUI(progress: 1.0, error: error)
            downloadSelf?.session?.invalidateAndCancel()
            downloadSelf?.session = nil
            downloadSelf?.responseData  = nil
        }
    }
}
