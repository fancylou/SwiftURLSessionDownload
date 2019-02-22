//
//  DownloadManagerTableViewController.swift
//  URLSessionDownloadDemo
//
//  Created by FancyLou on 2019/2/22.
//  Copyright © 2019 O2OA. All rights reserved.
//

import UIKit

class DownloadManagerTableViewController: UITableViewController {

    private var items:[String] = []
    private let modalUrls = [
        "https://obs-course.obs.cn-east-2.myhwclouds.com/develop_guide_simple_form.mp4"
        ,"https://obs-course.obs.cn-east-2.myhwclouds.com/how_to_use_workflow.mp4"
        ,"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550835840512&di=4490f345b01278065fe5d934af12ac0a&imgtype=0&src=http%3A%2F%2Fy0.ifengimg.com%2Fifengimcp%2Fpic%2F20140822%2Fd69e0188b714ee789e97_size87_w800_h1227.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "下载管理器Demo"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加任务", style: .plain, target: self, action: #selector(addTask))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.startDownload(url: items[indexPath.row])
        return cell
    }
    
    @objc private func addTask() {
        if items.count == 3 {
            print("没了。。。。。")
            return
        }
        let inx = items.count
        items.append(modalUrls[inx])
        self.tableView.reloadData()
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
