//
//  TableCell.swift
//  stalkr
//
//  Created by Edvaldo Junior on 21/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    var defaultAlpha: CGFloat = 0.4

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let bounds = self.imageView!.superview!.bounds
        let imageSize = CGSize(width: bounds.width * 0.07, height: bounds.height * 0.3)
        self.imageView?.frame = CGRect(x: bounds.width * 0.1, y: bounds.height / 2 - imageSize.height / 2, width: imageSize.width, height: imageSize.height)
        self.alpha = defaultAlpha
        self.textLabel?.textColor = UIColor(netHex: 0xB865D2)
        self.focusStyle = .custom
    }
}
