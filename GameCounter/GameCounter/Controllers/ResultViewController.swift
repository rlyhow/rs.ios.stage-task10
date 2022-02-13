//
//  ResultViewController.swift
//  GameCounter
//
//  Created by Mikita Shalima on 30.08.21.
//

import UIKit

class ResultViewController: UIViewController {

    // ЗАГОЛОВОК КОНТРОЛЛЕРА
    let labelText: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Results"
        label.textColor = .white
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        return label
    }()

    // STACK VIEW
    let scrollView = UIScrollView()
    let verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    // ТАБЛИЦА
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

    // Подгрузка данных
    // списки игроков и баллов
    var arrayOfPoints = UserDefaults.standard.object(forKey: "points") as? [Int] ?? []
    var arrayOfPlayers = UserDefaults.standard.object(forKey: "players") as? [String] ?? []
    // списки ходов
    var listOfMoves_Players = UserDefaults.standard.object(forKey: "listOfMoves_Players") as? [Int] ?? []
    var listOfMoves_Points = UserDefaults.standard.object(forKey: "listOfMoves_Points") as? [String] ?? []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
        
        setupLabel()
        setUpNavigationBar()
        
        setupScrollView()
        setupViewsInStack()
        setupTableView()
        
    }
}

private extension ResultViewController {

    func setupLabel(){
        view.addSubview(labelText)

        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            labelText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelText.heightAnchor.constraint(equalToConstant: 41),
            labelText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }

    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(verticalStack)
        scrollView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            verticalStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            verticalStack.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
        ])
    }
    
    func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            //tableView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    func setupViewsInStack(){
        var tuples = zip(arrayOfPlayers, arrayOfPoints).map { ($0, $1) }
        tuples.sort { ($0.0) < ($1.0) }
        tuples.sort { ($0.1) > ($1.1) }
        var first: Int = 1
        
        for i in 0...tuples.count - 1 {
            if (i == 0) { first = 1 } else {
                if (tuples[i].1 < tuples[i - 1].1) { first+=1 }
            }
            verticalStack.addArrangedSubview(ResultCellView(playerPlace: "# \(String(first))", playerName: tuples[i].0, playerScore: String(tuples[i].1)))
        }
    }
}

private extension ResultViewController {

    func setUpNavigationBar() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(closeResultsController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(openGameCounterController))

        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .highlighted)

        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .highlighted)
    }

    @objc func openGameCounterController() {
        let gameCounterView = GameCounterController()
        navigationController?.pushViewController(gameCounterView, animated: true)
    }

    @objc func closeResultsController() {
        navigationController?.popViewController(animated: true)
    }
}

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfMoves_Players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CellID")
        cell.textLabel?.text = arrayOfPlayers[listOfMoves_Players[indexPath.row]]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20.0)
        cell.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        cell.detailTextLabel?.text = listOfMoves_Points[indexPath.row]
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20.0)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 43))
        headerView.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 43))
        label.text = "Turns"
        label.textColor = UIColor(red: 0.518, green: 0.722, blue: 0.678, alpha: 1)
        label.font = UIFont (name: "Nunito-SemiBold", size: 16.0)
        headerView.addSubview(label)
        return headerView
    }
    
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 59))
        footerView.backgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
