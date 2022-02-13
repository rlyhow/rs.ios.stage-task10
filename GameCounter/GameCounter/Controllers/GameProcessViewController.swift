//
//  GameProcessViewController.swift
//  GameCounter
//
//  Created by Mikita Shalima on 27.08.21.
//

import UIKit

class GameProcessViewController: UIViewController {
    
    // КОЛЕКШН ВЬЮ
    private var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    
    // ТАЙМЕР
    var seconds = UserDefaults.standard.object(forKey: "timer") as? Int ?? 0
    var timer = Timer()
    var timerLabel = UILabel()
    var pauseTapped = false
    
    // НОМЕР ТЕКУЩЕГО ИГРОКА
    var currentPlayer = UserDefaults.standard.object(forKey: "currentTurn") as? Int ?? 0
    // списки игроков и баллов
    var arrayOfPoints = UserDefaults.standard.object(forKey: "points") as? [Int] ?? []
    var arrayOfPlayers = UserDefaults.standard.object(forKey: "players") as? [String] ?? []
    // списки ходов
    var listOfMoves_Players = UserDefaults.standard.object(forKey: "listOfMoves_Players") as? [Int] ?? []
    var listOfMoves_Points = UserDefaults.standard.object(forKey: "listOfMoves_Points") as? [String] ?? []
    
    // ЗАГОЛОВОК КОНТРОЛЛЕРА
    let labelText: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Game"
        label.textColor = .white
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        return label
    }()
    
    // КНОПКИ СТРЕЛОК
    let leftArrowButton = UIButton()
    let rightArrowButton = UIButton()
    
    //КНОПКА ОТМЕНЫ
    let undoButton = UIButton()
    
    // КНОПКА КУБИКА
    let diceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "dice_4"), for: .normal)
        button.addTarget(self, action: #selector(openDiceView), for: .touchUpInside)
        return button
    }()
    
    // КНОПКА ОСТНАВКИ И ЗАПУСКА ТАЙМЕРА
    let pauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Pause"), for: .normal)
        button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // НАСТРОЙКА КНОПОК С ОЧКАМИ
    let buttonPlusOne = BigPointButtonView()
    let horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    //PAGE CONTROL
    var pageScroll:PageControlSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1)
        
        setupLabel()
        setupDiceButton()
        setUpNavigationBar()
    
        setuptimerLabel()
        setupPauseButton()
        setupButtonPlusOne()
        runTimer()
        
        setupStackView()
        setupStackButtons()
        setupArrowButtons()
        setupUndoButton()
        
        setupCollectionView()
        
        setupPageControl()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayoutItemSize()
        
        if listOfMoves_Players.count == 0 {
            undoButton.isEnabled = false
            undoButton.alpha = 0.5
        } else {
            undoButton.isEnabled = true
            undoButton.alpha = 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        arrayOfPoints = UserDefaults.standard.object(forKey: "points") as? [Int] ?? []
        arrayOfPlayers = UserDefaults.standard.object(forKey: "players") as? [String] ?? []
        currentPlayer = UserDefaults.standard.object(forKey: "currentTurn") as? Int ?? 0
        
        listOfMoves_Players = UserDefaults.standard.object(forKey: "listOfMoves_Players") as? [Int] ?? []
        listOfMoves_Points = UserDefaults.standard.object(forKey: "listOfMoves_Points") as? [String] ?? []
        
        seconds = UserDefaults.standard.object(forKey: "timer") as? Int ?? 0
        
        if view.subviews.contains(pageScroll) { pageScroll.removeFromSuperview() }
        setupPageControl()
        view.layoutIfNeeded()
        
        collectionView.reloadData()
        
        if pauseTapped == true {
            pauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            runTimer()
            pauseTapped = false
        }
        
        setImageArrowButton()
        pageScroll.changeOpacity(currentPlayer: currentPlayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        collectionView.scrollToItem(at: IndexPath(item: currentPlayer, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        UserDefaults.standard.setValue(seconds, forKey: "timer")
    }
    
    func setupStackButtons(){
        let points = ["-10", "-5", "-1", "+5", "+10"]
        for item in points {
            let button = SmallPointButtonView(title: item)
            button.addTarget(self, action: #selector(changePoints), for: .touchUpInside)
            horizontalStack.addArrangedSubview(button)
        }
    }
    
    func setupCollectionView() {
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView?.backgroundColor = .clear
        collectionView?.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
             collectionView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: buttonPlusOne.topAnchor, constant: -20),
             collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView?.delegate = self
    }
    
    
    // START TIMER FUNCTIONS
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func updateTimer(){
        seconds += 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
        UserDefaults.standard.setValue(seconds, forKey: "timer")
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc func pauseButtonTapped() {
        if pauseTapped == false {
            pauseButton.setImage(UIImage(named: "Play"), for: .normal)
            timer.invalidate()
            pauseTapped = true
        } else {
            pauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            runTimer()
            pauseTapped = false
        }
    }
    // END TIMER FUNCTIONS
    
    
    // НАСТРОЙКА КОЛЕКШН ВЬЮ АЙТЕМОВ
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = 60
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        flowLayout.itemSize = CGSize(width: collectionView.frame.size.width - inset * 2, height: collectionView.frame.size.height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = flowLayout.itemSize.width
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(arrayOfPlayers.count - 1, index))
        return safeIndex
    }
}

// START COLLECTION
extension GameProcessViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPlayers.count // How many cells to display
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let imageCell:CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CustomCollectionViewCell
        
        imageCell.playerName.text = arrayOfPlayers[indexPath.row]
        imageCell.playerScore.text = String(arrayOfPoints[indexPath.row])
                
        return imageCell
    }
}

extension GameProcessViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = indexOfMajorCell()
        
        // This is a much better way to scroll to a cell:
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        //
        currentPlayer = indexPath.row
        UserDefaults.standard.setValue(currentPlayer, forKey: "currentTurn")
        setImageArrowButton()
        pageScroll.changeOpacity(currentPlayer: currentPlayer)
    }
    
    
    
}

extension GameProcessViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
// END COLLECTION

// START SETUP CONSTRAINTS
private extension GameProcessViewController {
    
    func setupLabel(){
        view.addSubview(labelText)
        
        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            labelText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelText.heightAnchor.constraint(equalToConstant: 41),
            labelText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }
    
    func setupDiceButton(){
        view.addSubview(diceButton)
        
        NSLayoutConstraint.activate([
            diceButton.heightAnchor.constraint(equalToConstant: 30),
            diceButton.widthAnchor.constraint(equalToConstant: 30),
            diceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            diceButton.centerYAnchor.constraint(equalTo: labelText.centerYAnchor)
        ])
    }
    
    func setupPauseButton(){
        view.addSubview(pauseButton)
        
        NSLayoutConstraint.activate([
            pauseButton.heightAnchor.constraint(equalTo: timerLabel.heightAnchor, multiplier: 0.53),
            pauseButton.widthAnchor.constraint(equalTo: pauseButton.heightAnchor, multiplier: 0.8),
            pauseButton.leadingAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: 20),
            pauseButton.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor)
        ])
    }
    
    func setuptimerLabel(){
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.text = "00:00"
        timerLabel.font = UIFont(name: "Nunito-ExtraBold", size: 28.0)
        timerLabel.textColor = .white
        view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.heightAnchor.constraint(equalToConstant: 41),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 29.0)
        ])
    }
    
    func setupButtonPlusOne(){
        buttonPlusOne.addTarget(self, action: #selector(changePoints), for: .touchUpInside)
        buttonPlusOne.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonPlusOne)
        
        NSLayoutConstraint.activate([
            buttonPlusOne.heightAnchor.constraint(equalToConstant: 90),
            buttonPlusOne.widthAnchor.constraint(equalToConstant: 90),
            buttonPlusOne.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            buttonPlusOne.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupStackView() {
        view.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: buttonPlusOne.bottomAnchor, constant: 22),
            horizontalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupArrowButtons() {
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        leftArrowButton.addTarget(self, action: #selector(scrollByArrow), for: .touchUpInside)
        
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.addTarget(self, action: #selector(scrollByArrow), for: .touchUpInside)
        
        view.addSubview(leftArrowButton)
        view.addSubview(rightArrowButton)
        
        setImageArrowButton()
        
        NSLayoutConstraint.activate([
            leftArrowButton.trailingAnchor.constraint(equalTo: buttonPlusOne.leadingAnchor, constant: -63),
            leftArrowButton.centerYAnchor.constraint(equalTo: buttonPlusOne.centerYAnchor),
            
            rightArrowButton.leadingAnchor.constraint(equalTo: buttonPlusOne.trailingAnchor, constant: 63),
            rightArrowButton.centerYAnchor.constraint(equalTo: buttonPlusOne.centerYAnchor)
        ])
    }
    
    func setupUndoButton() {
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.addTarget(self, action: #selector(undoLastMove), for: .touchUpInside)
        undoButton.setImage(UIImage(named: "Undo"), for: .normal)
        view.addSubview(undoButton)
        
        NSLayoutConstraint.activate([
            undoButton.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor),
            undoButton.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 22),
        ])
    }
    
    func setupPageControl() {
        pageScroll = PageControlSlider(labels: arrayOfPlayers, current: currentPlayer)
        view.addSubview(pageScroll)
        NSLayoutConstraint.activate([
            pageScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageScroll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageScroll.heightAnchor.constraint(equalToConstant: 24),
            pageScroll.widthAnchor.constraint(equalToConstant: 58),
        ])
    }
}

// END SETUP CONSTRAINTS

private extension GameProcessViewController {
    
    @objc func openGameCounterController() {
        let gameCounterView = GameCounterController()
        
        if pauseTapped == false {
            pauseButton.setImage(UIImage(named: "Play"), for: .normal)
            timer.invalidate()
            pauseTapped = true
        }
        navigationController?.pushViewController(gameCounterView, animated: true)
    }
    
    @objc func openResultsController() {
        let resultView = ResultViewController()
        
        if pauseTapped == false {
            pauseButton.setImage(UIImage(named: "Play"), for: .normal)
            timer.invalidate()
            pauseTapped = true
        }
        navigationController?.pushViewController(resultView, animated: true)
    }
    
    @objc func openDiceView() {
        let diceView = DiceViewController()
        diceView.modalPresentationStyle = .overFullScreen
        present(diceView, animated: false)
    }
    
    @objc func changePoints(sender: UIButton) {
        
        let cell = collectionView.cellForItem(at: IndexPath(item: currentPlayer, section: 0)) as! CustomCollectionViewCell
        let newScore = Int(cell.playerScore.text!)! + Int((sender.titleLabel?.text)!)!
        cell.playerScore.text = String(newScore)
        arrayOfPoints[currentPlayer] = newScore
        
        listOfMoves_Players.append(currentPlayer)
        listOfMoves_Points.append(sender.titleLabel!.text!)
        
        UserDefaults.standard.setValue(arrayOfPoints, forKey: "points")
        UserDefaults.standard.setValue(listOfMoves_Players, forKey: "listOfMoves_Players")
        UserDefaults.standard.setValue(listOfMoves_Points, forKey: "listOfMoves_Points")
        
        if currentPlayer == arrayOfPlayers.count-1 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            currentPlayer = 0
        } else {
            collectionView.scrollToItem(at: IndexPath(item: currentPlayer + 1, section: 0), at: .centeredHorizontally, animated: true)
            currentPlayer += 1
        }
        
        UserDefaults.standard.setValue(currentPlayer, forKey: "currentTurn")
        
        setImageArrowButton()
        pageScroll.changeOpacity(currentPlayer: currentPlayer)
    }
    
    @objc func scrollByArrow(sender: UIButton) {
        switch sender {
        case leftArrowButton:
            if currentPlayer == 0 {
                collectionView.scrollToItem(at: IndexPath(item: arrayOfPlayers.count-1, section: 0), at: .centeredHorizontally, animated: true)
                currentPlayer = arrayOfPlayers.count-1
            } else {
                collectionView.scrollToItem(at: IndexPath(item: currentPlayer - 1, section: 0), at: .centeredHorizontally, animated: true)
                currentPlayer -= 1
            }
            
        case rightArrowButton:
            if currentPlayer == arrayOfPlayers.count-1 {
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                currentPlayer = 0
            } else {
                collectionView.scrollToItem(at: IndexPath(item: currentPlayer + 1, section: 0), at: .centeredHorizontally, animated: true)
                currentPlayer += 1
            }
        default:
            print("default")
        }
        
        UserDefaults.standard.setValue(currentPlayer, forKey: "currentTurn")
        
        setImageArrowButton()
        pageScroll.changeOpacity(currentPlayer: currentPlayer)
        //pageScroll.setContentOffset(CGPoint(x: 19, y: 0), animated: true)
    }
    
    @objc func undoLastMove() {
        let index = listOfMoves_Players.removeLast()
        let points = listOfMoves_Points.removeLast()
        
        UserDefaults.standard.setValue(listOfMoves_Players, forKey: "listOfMoves_Players")
        UserDefaults.standard.setValue(listOfMoves_Points, forKey: "listOfMoves_Points")
        UserDefaults.standard.setValue(index, forKey: "currentTurn")
        
        arrayOfPoints[index] = arrayOfPoints[index] - Int(points)!
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        
        UserDefaults.standard.setValue(arrayOfPoints, forKey: "points")
        currentPlayer = UserDefaults.standard.object(forKey: "currentTurn") as? Int ?? 0

        setImageArrowButton()
        pageScroll.changeOpacity(currentPlayer: currentPlayer)
    }
    
    func setImageArrowButton()  {
        if (currentPlayer == 0) {
            leftArrowButton.setImage(UIImage(named: "icon_Previous_left"), for: .normal)
        } else {
            leftArrowButton.setImage(UIImage(named: "icon_Next_left"), for: .normal)
        }
        
        if (currentPlayer == arrayOfPlayers.count - 1) {
            rightArrowButton.setImage(UIImage(named: "icon_Previous_right"), for: .normal)
        } else {
            rightArrowButton.setImage(UIImage(named: "icon_Next_right"), for: .normal)
        }
    }
    
    func setUpNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Results", style: .plain, target: self, action: #selector(openResultsController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(openGameCounterController))
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .highlighted)
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!], for: .highlighted)
    }
}



