//
//  CustomTableViewCell.swift
//  GameCounter
//
//  Created by Mikita Shalima on 26.08.21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews where view.description.contains("Edit") {
            for case let subview as UIImageView in view.subviews {
                if (self.isSelected) {
                    subview.image = UIImage(named: "icon_Delete.pdf")
                }else {
                    subview.image = UIImage(named: "icon_Delete.pdf")
                }
               
            }
        }
        
        for view in subviews where view.description.contains("Reorder") {
            for case let subview as UIImageView in view.subviews {
                subview.image = UIImage(named: "icon_Sort.pdf")
            }
        }
        
    }

}
