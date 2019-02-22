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
    @IBOutlet weak var startBtn: UIButton!
    
    private var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tapStartBtn(_ sender: UIButton) {
        if self.startBtn.currentTitle == "开始" {
            self.statusText.text = "开始下载"
            self.startBtn.setTitle("取消", for: .normal)
            weak var weakCell = self
            DownloaderManager.shared.download(url: URL(string: self.url!)!, progress: { (p) in
                DispatchQueue.main.async {
                    weakCell?.progressView.progress = p
                    weakCell?.statusText.text = String(p*100)+"%"
                }
                
            }, completion: { (filePath) in
                print("下载完成：\(filePath)")
                DispatchQueue.main.async {
                    weakCell?.statusText.text = "完成"
                    weakCell?.startBtn.setTitle("开始", for: .normal)
                }
            }) { (error) in
                //self.statusText.text = "下载失败"
                print("下载失败:\(error)")
            }
        }else {
            self.startBtn.setTitle("开始", for: .normal)
            DownloaderManager.shared.cancelTask(url: URL(string: self.url!)!)
        }
        
    }
    func setUp(url: String) {
        self.url = url
    }

}
