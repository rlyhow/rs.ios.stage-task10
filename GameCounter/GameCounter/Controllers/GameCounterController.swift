//
//  GameCounterController.swift
//  GameCounter
//
//  Created by Mikita Shalima on 25.08.21.
//

import UIKit

class GameCounterController: UIViewController {
    
    //static var dataSource = ["You", "Me", "Mikita", "Andrey"]
    static var dataSourceOfNames = UserDefaults.standard.object(forKey: "players") as? [String] ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "countOfOpen") as? String == "cancelOpened" {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeController))
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .normal)
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .highlighted)
        }
        
        view.backgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
        
        setupLabel()
        setupButtonStartGame()
        setupTableView()
        tableView.setEditing(true, animated: true)
        
        view.bringSubviewToFront(buttonStartGame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if GameCounterController.dataSourceOfNames.count == 0 {
            buttonStartGame.isEnabled = false
            buttonStartGame.alpha = 0.5
        } else {
            buttonStartGame.isEnabled = true
            buttonStartGame.alpha = 1
        }
    }
    
    let labelText: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Game Counter"
        label.textColor = .white
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        return label
    }()
    
    var buttonStartGame: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.518, green: 0.722, blue: 0.678, alpha: 1)
        button.layer.cornerRadius = 35
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 24.0)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Start game", for: .normal)
        
        button.layer.shadowColor = UIColor(red: 84/255.0, green: 120/255.0, blue: 111/255.0, alpha: 1.0).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        
        button.titleLabel!.layer.shadowColor = UIColor(red: 0.329, green: 0.471, blue: 0.435, alpha: 1).cgColor
        button.titleLabel!.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.titleLabel!.layer.shadowOpacity = 1.0
        button.titleLabel!.layer.shadowRadius = 0.0
        button.titleLabel!.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }()
    
    private let tableView: UITableView = {
        let view = CustomTable(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        view.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        view.layer.cornerRadius = 15.0
        view.estimatedSectionFooterHeight = 59.0
        view.estimatedSectionHeaderHeight = 43.0
        view.separatorColor = UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1)
        
        return view
    }()
    
}

private extension GameCounterController {
    
    func setupLabel(){
        view.addSubview(labelText)
        
        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            labelText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelText.heightAnchor.constraint(equalToConstant: 41),
            labelText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }
    
    func setupButtonStartGame(){
        view.addSubview(buttonStartGame)
        
        NSLayoutConstraint.activate([
            buttonStartGame.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStartGame.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStartGame.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            buttonStartGame.heightAnchor.constraint(equalToConstant: 65.0)
        ])
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 25),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: buttonStartGame.topAnchor, constant: -10),
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension GameCounterController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        GameCounterController.dataSourceOfNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CustomTableViewCell(style: .default, reuseIdentifier: "CellID")
        cell.textLabel?.text = GameCounterController.dataSourceOfNames[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20.0)
        cell.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 43))
        headerView.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 43))
        label.text = "Players"
        label.textColor = UIColor(red: 0.518, green: 0.722, blue: 0.678, alpha: 1)
        label.font = UIFont (name: "Nunito-SemiBold", size: 16.0)
        headerView.addSubview(label)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 59))
        footerView.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        
        let addPlayerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 59))
        addPlayerBtn.contentHorizontalAlignment = .left
        addPlayerBtn.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        addPlayerBtn.setImage(UIImage(named: "Add.pdf"), for: .normal)
        addPlayerBtn.setTitle("Add player", for: .normal)
        addPlayerBtn.setTitleColor(UIColor(red: 0.518, green: 0.722, blue: 0.678, alpha: 1), for: .normal)
        addPlayerBtn.setTitleColor(UIColor(red: 0.518, green: 0.722, blue: 0.678, alpha: 0.5), for: .highlighted)
        addPlayerBtn.titleLabel?.font = UIFont (name: "Nunito-SemiBold", size: 16.0)
        addPlayerBtn.addTarget(self, action: #selector(openAddPlayerViewController), for: .touchUpInside)
        addPlayerBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        addPlayerBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        footerView.addSubview(addPlayerBtn)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension GameCounterController {
    @objc func startGame() {
        UserDefaults.standard.setValue(GameCounterController.dataSourceOfNames, forKey: "players")
        
        let dataSourceOfPoints = Array(repeating: 0, count: GameCounterController.dataSourceOfNames.count)
        let listOfMoves_Players:[String] = []
        let listOfMoves_Points:[String] = []
        
        UserDefaults.standard.setValue(dataSourceOfPoints, forKey: "points")
        UserDefaults.standard.setValue(0, forKey: "currentTurn")
        UserDefaults.standard.setValue(listOfMoves_Players, forKey: "listOfMoves_Players")
        UserDefaults.standard.setValue(listOfMoves_Points, forKey: "listOfMoves_Points")
        UserDefaults.standard.setValue(0, forKey: "timer")
        
        if UserDefaults.standard.object(forKey: "countOfOpen") as? String == "Opened" {
            UserDefaults.standard.setValue("cancelOpened", forKey: "countOfOpen")
            
            let gameProcessController = GameProcessViewController()
            navigationController?.pushViewController(gameProcessController, animated: true)
            navigationController?.viewControllers = [gameProcessController]
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func closeController() {
        GameCounterController.dataSourceOfNames = UserDefaults.standard.object(forKey: "players") as? [String] ?? []
        navigationController?.popViewController(animated: true)
    }
}


extension GameCounterController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            GameCounterController.dataSourceOfNames.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = GameCounterController.dataSourceOfNames[sourceIndexPath.row]
        GameCounterController.dataSourceOfNames.remove(at: sourceIndexPath.row)
        GameCounterController.dataSourceOfNames.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    @objc func openAddPlayerViewController() {
        self.navigationController?.pushViewController(AddPlayerViewController(), animated: true)
    }
    
}

