//
//  PageControlSlider.swift
//  GameCounter
//
//  Created by Mikita Shalima on 31.08.21.
//

import UIKit

class PageControlSlider: UIScrollView {
    
    var arrayOfLabels:[String]
    var currentPlayer: Int
    
    var litera: [UILabel] = []
    var stackView: UIStackView = UIStackView()
    
    init(labels: [String], current: Int) {
        self.arrayOfLabels = labels
        self.currentPlayer = current
        
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for item in arrayOfLabels {
            let label = UILabel()
            label.text = item[0]
            label.textColor = .red
            label.font = UIFont(name: "Nunito-ExtraBold", size: 20)
            litera.append(label)
        }
        
        for item in litera {
            item.alpha = 0.5
            stackView.addArrangedSubview(item)
        }
        
        litera[currentPlayer].alpha = 1
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo:leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    
    func changeOpacity(currentPlayer: Int) {
        for item in litera where item.alpha == 1{
            item.alpha = 0.5
        }
        litera[currentPlayer].alpha = 1
        
        if litera.count < 4 {
            setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if currentPlayer > litera.count - 2 {
            setContentOffset(CGPoint(x: litera[currentPlayer-2].frame.origin.x, y: 0), animated: true)
        } else if currentPlayer > 1 {
            setContentOffset(CGPoint(x: litera[currentPlayer-1].frame.origin.x, y: 0), animated: true)
        } else {
            setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }

}
