//
//  CustomTable.swift
//  GameCounter
//
//  Created by Mikita Shalima on 26.08.21.
//

import UIKit

class CustomTable: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override var intrinsicContentSize: CGSize {
        let height = min(maxHeight, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    
}
