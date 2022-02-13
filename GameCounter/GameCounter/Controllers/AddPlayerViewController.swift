//
//  AddPlayerViewController.swift
//  GameCounter
//
//  Created by Mikita Shalima on 26.08.21.
//

import UIKit

class AddPlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
        setUpNavigationBar()
        setupLabel()
        setupTextField()
        
        textField.becomeFirstResponder() // focuse on textField
        textField.delegate = self
    }
    
    let labelText: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Player"
        label.textColor = .white
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        return label
    }()
    
    let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(string: "Player Name",
                                                         attributes: [
                                                            NSAttributedString.Key.foregroundColor: UIColor(red: 0.608, green: 0.608, blue: 0.631, alpha: 1),
                                                            NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 20)!,
                                                         ])
        field.textColor = .white
        field.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        field.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: field.frame.height))
        field.leftViewMode = .always
        field.addTarget(self, action: #selector(checkTextFieldIsEmpty), for: .editingChanged)
        field.keyboardAppearance = .dark
        return field
    }()
    
    func setUpNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewPlayer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pushBack))
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .highlighted)
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .highlighted)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .disabled)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func pushBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewPlayer() {
        GameCounterController.dataSourceOfNames.append(textField.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkTextFieldIsEmpty() {
        if textField.text!.isEmpty || textField.text!.count > 12 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
}

private extension AddPlayerViewController {
    func setupLabel(){
        view.addSubview(labelText)
        
        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            labelText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelText.heightAnchor.constraint(equalToConstant: 41),
            labelText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }
    
    func setupTextField(){
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 60),
            textField.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 25)
        ])
    }
}

extension AddPlayerViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
}
