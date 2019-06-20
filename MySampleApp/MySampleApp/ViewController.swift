//
//  ViewController.swift
//  MySampleApp
//
//  Created by Eunbae Ko on 2019/06/19.
//  Copyright © 2019年 Eunbae Ko. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController, ResponseHandler, UITextViewDelegate, SendHistoryData, NVActivityIndicatorViewable {

    @IBOutlet weak var japaneseField: UITextView!
    @IBOutlet weak var hiraganaField: UITextView!
    @IBOutlet weak var guideLabel: UILabel!
    
    private lazy var httpRequest = HttpRequest(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    // 変換動作：APIリクエストを行う
    @IBAction
    func actionConvert() {
        if let japanese = japaneseField.text, !japanese.isEmpty {
            startAnimating(CGSize(width: 20, height: 20), type: .lineSpinFadeLoader, color: .white)
            httpRequest.post(japanese)
        } else {
            let alert = UIAlertController(title: "エラー", message: "文章を入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // クリア動作：全てのテキストをクリア
    @IBAction
    func actionClear() {
        japaneseField.text = ""
        hiraganaField.text = ""
        
        japaneseField.becomeFirstResponder()
    }
    
    // 履歴動作：履歴画面へ遷移
    @IBAction
    func actionHistory() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController {
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // 変換成功時の処理
    func done(result: String) {
        hiraganaField.text = result
        self.view.endEditing(true)
        
        var historyArray = UserDefaults.standard.array(forKey: ConvertHistory.preferenceKey) as? [[String:String]] ?? []
        
        // 変換結果を履歴として保存する。３０件まで
        let history: [String:String] = [
            ConvertHistory.original : self.japaneseField.text,
            ConvertHistory.converted : result
        ]
        historyArray.append(history)
        if historyArray.count > 30 {
            historyArray.removeFirst(historyArray.count - 30)
        }
        UserDefaults.standard.set(historyArray, forKey: ConvertHistory.preferenceKey)
        
        stopAnimating()
    }
    
    // 変換失敗時の処理
    func failed(message: String) {
        let alert = UIAlertController(title: "失敗", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        stopAnimating()
    }
    
    // 履歴画面から受け取った変換を表示
    func send(original: String, converted: String) {
        japaneseField.text = original
        hiraganaField.text = converted
        
        guideLabel.isHidden = true
    }
    
    // MARK: - TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 入力テキストビューを強調する
        textView.borderWidth = 3
        guideLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        japaneseField.borderWidth = 0
        if japaneseField.text.isEmpty {
            guideLabel.isHidden = false
        }
    }
    
    // MARK: - Selector
    @objc
    func tapGesture(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}
