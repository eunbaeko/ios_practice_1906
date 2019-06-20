//
//  HistoryViewController.swift
//  MySampleApp
//
//  Created by Eunbae Ko on 2019/06/19.
//  Copyright © 2019年 Eunbae Ko. All rights reserved.
//

import UIKit

// 選択された履歴の内容を渡すprotocol
protocol SendHistoryData {
    func send(original: String, converted: String)
}

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: SendHistoryData?
    private var historyArray: [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyArray = UserDefaults.standard.array(forKey: ConvertHistory.preferenceKey) as? [[String:String]] ?? []
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell {
            cell.setContent(historyArray[indexPath.row])
            return cell
            
        } else {
            let cell = HistoryTableViewCell()
            cell.setContent(historyArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = historyArray[indexPath.row]
        if let original = history[ConvertHistory.original], let converted = history[ConvertHistory.converted] {
            delegate?.send(original: original, converted: converted)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
