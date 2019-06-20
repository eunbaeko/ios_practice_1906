//
//  HistoryTableViewCell.swift
//  MySampleApp
//
//  Created by Eunbae Ko on 2019/06/19.
//  Copyright © 2019年 Eunbae Ko. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var convertedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clearLabels()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearLabels()
    }
    
    func clearLabels() {
        originalLabel.text = ""
        convertedLabel.text = ""
    }
    
    func setContent(_ data: [String:String]) {
        originalLabel.text = data[ConvertHistory.original]
        convertedLabel.text = data[ConvertHistory.converted]
    }

}
