//
//  TaskTableViewCell.swift
//  URLSessionDownloadDemo
//
//  Created by FancyLou on 2019/2/22.
//  Copyright © 2019 O2OA. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var statusText: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func startDownload(url: String) {
        self.url = url
        self.statusText.text = "开始下载"
        weak var weakCell = self
        DownloaderManager.shared.download(url: URL(string: url)!, progress: { (p) in
            DispatchQueue.main.async {
                weakCell?.progressView.progress = p
                weakCell?.statusText.text = String(p*100)+"%"
            }
            
        }, completion: { (filePath) in
            print("下载完成：\(filePath)")
            DispatchQueue.main.async {
                weakCell?.statusText.text = "完成"
            }
        }) { (error) in
            //self.statusText.text = "下载失败"
            print("下载失败:\(error)")
        }
    }

}
