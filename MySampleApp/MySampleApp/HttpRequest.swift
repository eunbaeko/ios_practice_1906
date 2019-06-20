//
//  HttpRequest.swift
//  MySampleApp
//
//  Created by Eunbae Ko on 2019/06/19.
//  Copyright © 2019年 Eunbae Ko. All rights reserved.
//

import Foundation
import Alamofire

protocol ResponseHandler {
    func done(result: String)
    func failed(message: String)
}

class HttpRequest {

    var delegate: ResponseHandler?
    
    init(_ handler: ResponseHandler) {
        self.delegate = handler
    }
    
    func post(_ text: String) {
        
        let params = [
            "app_id" : "799c1ac7b61f3b258aca727520771f4ca9cda87ae2ce3baddef238514906f8ee",
            "output_type" : "hiragana",
            "sentence" : text
        ]
        
        Alamofire.request("https://labs.goo.ne.jp/api/hiragana", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
            guard response.error == nil else {
                self.delegate?.failed(message: "APIサーバーとの通信が失敗しました。")
                return
            }
            
            if let json = response.result.value {
                if let dic = json as? [String:Any], let converted = dic["converted"] as? String{
                    self.delegate?.done(result: converted)
                    return
                }
            }
            self.delegate?.failed(message: "文字列を変換することができませんでした。")
        }
    }
    
}
