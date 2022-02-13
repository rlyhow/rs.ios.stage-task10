//
//  ResultCellView.swift
//  GameCounter
//
//  Created by Mikita Shalima on 30.08.21.
//

import UIKit

class ResultCellView: UIView {

    var playerPlace:UILabel = UILabel()
    var playerName:UILabel = UILabel()
    var playerScore:UILabel = UILabel()
    
    var playerPlaceString:String!
    var playerNameString:String!
    var playerScoreString:String!
    
    
    init(playerPlace: String, playerName: String, playerScore: String) {
        super.init(frame: .zero)
        
        self.playerPlaceString = playerPlace
        self.playerNameString = playerName
        self.playerScoreString = playerScore
        
        setupCell()
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        
        backgroundColor = .clear
    }
    
    func setupPlayer() {
        
        playerPlace.text = playerPlaceString
        playerPlace.textColor = .white
        playerPlace.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        playerPlace.textAlignment = .left
        
        playerName.text = playerNameString
        playerName.textColor = UIColor(red: 0.922, green: 0.682, blue: 0.408, alpha: 1)
        playerName.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        playerName.textAlignment = .left
        playerName.lineBreakMode = .byTruncatingTail
        
        playerScore.text = playerScoreString
        playerScore.textColor = .white
        playerScore.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        playerScore.textAlignment = .left
        
        addSubview(playerPlace)
        addSubview(playerName)
        addSubview(playerScore)
        
        playerPlace.translatesAutoresizingMaskIntoConstraints = false
        playerName.translatesAutoresizingMaskIntoConstraints = false
        playerScore.translatesAutoresizingMaskIntoConstraints = false
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                      
            playerPlace.topAnchor.constraint(equalTo: topAnchor),
            playerPlace.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerPlace.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            playerScore.topAnchor.constraint(equalTo: topAnchor),
            playerScore.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerScore.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            playerName.topAnchor.constraint(equalTo: topAnchor),
            playerName.bottomAnchor.constraint(equalTo: bottomAnchor),
            playerName.leadingAnchor.constraint(equalTo: playerPlace.trailingAnchor, constant: 15),
            
            heightAnchor.constraint(equalToConstant: 41),
        ])
    }

}
