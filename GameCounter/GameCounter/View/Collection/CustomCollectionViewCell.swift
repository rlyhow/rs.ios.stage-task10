//
//  ImageCollectionViewCell.swift
//  GameCounter
//
//  Created by Mikita Shalima on 28.08.21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    var playerName:UILabel!
    var playerScore:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        playerName = UILabel()
        playerScore = UILabel()
        
        setupCell()
        setupPlayerName()
        setupPlayerScore()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        
        backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        layer.cornerRadius = 15
    }
    
    func setupPlayerName() {
        playerName.textColor = UIColor(red: 0.922, green: 0.682, blue: 0.408, alpha: 1)
        playerName.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        playerName.textAlignment = .center
        
        addSubview(playerName)
        playerName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerName.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            playerName.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerName.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerName.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setupPlayerScore() {
        playerScore.textColor = .white
        playerScore.font = UIFont(name: "Nunito-Bold", size: 100)
        playerScore.textAlignment = .center
        
        addSubview(playerScore)
        playerScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerScore.centerXAnchor.constraint(equalTo: centerXAnchor),
            playerScore.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
