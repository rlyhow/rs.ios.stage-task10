//
//  DiceViewController.swift
//  GameCounter
//
//  Created by Mikita Shalima on 27.08.21.
//

import UIKit
import AudioToolbox

class DiceViewController: UIViewController {
    
    lazy var blurredBackgroundView = UIVisualEffectView()
    lazy var diceImageArray: [UIImage] = [UIImage(named: "dice_1")!,
                                     UIImage(named: "dice_2")!,
                                     UIImage(named: "dice_3")!,
                                     UIImage(named: "dice_4")!,
                                     UIImage(named: "dice_5")!,
                                     UIImage(named: "dice_6")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setBlurViewConstraints()
        setDiceImageConstraints()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
       
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(closeDice))
        view.addGestureRecognizer(viewTap)
    }
    
    @objc func closeDice() {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension DiceViewController {
    func setBlurViewConstraints() {
        
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurredBackgroundView)
        
        NSLayoutConstraint.activate([
            blurredBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            blurredBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurredBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurredBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    func setDiceImageConstraints() {
        
        let diceImageView = UIImageView(image: diceImageArray.randomElement())
        diceImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(diceImageView)
        
        NSLayoutConstraint.activate([
            diceImageView.heightAnchor.constraint(equalToConstant: 120),
            diceImageView.widthAnchor.constraint(equalToConstant: 120),
            diceImageView.centerXAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor),
            diceImageView.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor)
        ])
    }
    
}
