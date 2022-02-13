//
//  SmallPointButtonView.swift
//  GameCounter
//
//  Created by Mikita Shalima on 28.08.21.
//

import UIKit

class SmallPointButtonView: UIButton {

    var pointNumber:String!
    private var touchPath: UIBezierPath { return UIBezierPath(ovalIn: self.bounds)}
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.pointNumber = title
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
    
        backgroundColor = UIColor(red: 0.518, green: 0.722, blue: 0.678, alpha: 1)
        setTitle(pointNumber, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .highlighted)
        titleLabel?.font = UIFont (name: "Nunito-ExtraBold", size: 25.0)
        
        titleLabel!.layer.shadowColor = UIColor(red: 0.329, green: 0.471, blue: 0.435, alpha: 1).cgColor
        titleLabel!.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        titleLabel!.layer.shadowOpacity = 1.0
        titleLabel!.layer.shadowRadius = 0.0
        titleLabel!.layer.masksToBounds = false
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 55).isActive = true
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }

}
