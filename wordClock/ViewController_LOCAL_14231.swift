//
//  ViewController.swift
//  wordClock
//
//  Created by Александр Рахимов on 26.11.2022.
//

import UIKit

final class ViewController: UIViewController {

    let model = Model.model
    
    var initialOrientation = true
    var portraitOrientation: Bool {
        get {
            if view.frame.width < view.frame.height {
                initialOrientation = true
                return true
            } else {
                initialOrientation = false
                return false
            }
        }
    }
    
    let settingButton = UIButton()
    let containerView = UIView()
    var wordLabelsArray = [UILabel]()
    var noMarksMinutesLabels = [UILabel]()
    
    var indexOfLabels = [Int]()
    
    var myTimer = Timer()
    let period = 1
    var countOfSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.myTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.period), target: self, selector: #selector(self.forTimer), userInfo: nil, repeats: true)
        }
        createGestureToMainView()
        settingButton.addTarget(self, action: #selector(pushSettingButton), for: .touchUpInside)
        settingButton.setTitleColor(model.textColor, for: .normal)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if !portraitOrientation {
            settingButton.isHidden = true
        } else {
            settingButton.isHidden = false
        }
        
        settingButton.isHidden.toggle()
    }
    
    override func viewWillLayoutSubviews() {
        containerView.center = self.view.center
    }
    
    private func start() {
        createSettingButton()
        createContainerView()
        createWordLabels()
        createNoMarkMinutes()
    }
    
    
    //MARK: add gesture to mainView
    private func createGestureToMainView() {
        let mainGesture = UITapGestureRecognizer(target: self, action: #selector(tapForGoToNextScreen(gesture:)))
        self.view.addGestureRecognizer(mainGesture)
    }
    
    
    //MARK: - create views and word labels
    private func createContainerView() {
        var sideOfContainerView: CGFloat = 0
        if initialOrientation {
            sideOfContainerView = (view.bounds.size.width / 12) * 11
        } else {
            sideOfContainerView = (view.bounds.size.height / 12) * 11
        }
        containerView.frame = CGRect(x: 0, y: 0, width: sideOfContainerView, height: sideOfContainerView)
        self.view.addSubview(containerView)
    }
    
    private func createWordLabels() {
        
        let sideOfLabel = containerView.bounds.size.width / 11
        
        var coordinateX = 0
        var coordinateY = 0
        
        for (index, value) in model.labelOfWordViews.enumerated() {
            
            if index % 11 == 0 && index != 0 {
                coordinateY += Int(sideOfLabel)
                coordinateX = 0
            }
            
            let newLabel = UILabel(frame: CGRect(x: CGFloat(coordinateX), y: CGFloat(coordinateY), width: sideOfLabel, height: sideOfLabel))
            newLabel.text = value
            newLabel.textColor = .darkGray
            newLabel.font = UIFont.init(name: "Courier", size: 25)
            newLabel.textAlignment = .center
            newLabel.tag = index
            
            let labelGesture = UIPanGestureRecognizer(target: self, action: #selector(highlightWordsAfterPan(gesture:)))
            containerView.addGestureRecognizer(labelGesture)
            
            wordLabelsArray.append(newLabel)
            containerView.addSubview(newLabel)
            coordinateX += Int(sideOfLabel)
        }
    }
    
    private func createNoMarkMinutes() {
        
        let sideOfLabel = containerView.bounds.size.width / 11
        var coordinateX = containerView.center.x - (sideOfLabel * 2)
        let coordinateY = containerView.bounds.size.height - (sideOfLabel / 2)
        
        for (index, value) in model.labelsOfNomarkMinutesView.enumerated() {
            
            let newLabel = UILabel()
            newLabel.frame = CGRect(x: 0, y: 0, width: sideOfLabel, height: sideOfLabel)
            newLabel.center = CGPoint(x: coordinateX, y: coordinateY)
            newLabel.text = value
            newLabel.textColor = .darkGray
            newLabel.font = UIFont.init(name: "Courier", size: 25)
            newLabel.textAlignment = .center
            newLabel.tag = model.labelOfWordViews.count + index + 1
            wordLabelsArray.append(newLabel)
            containerView.addSubview(newLabel)
            coordinateX += sideOfLabel
        }
    }

    //MARK: What label must light
    
    private func whatLabelsMustLight() {
        
        indexOfLabels = model.whatTimeIsIt()
                
        for (index, label) in wordLabelsArray.enumerated() {
            if indexOfLabels.contains(index) {
                label.textColor = model.textColor
            } else {
                label.textColor = .darkGray
            }
        }
    }
    
    //MARK: create setting button
    
    private func createSettingButton() {
        guard portraitOrientation else { return }
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.setTitle("ADJUST", for: .normal)
        settingButton.setTitleColor(model.textColor, for: .normal)
        settingButton.titleLabel?.font = UIFont.init(name: "Courier", size: 25)
        self.view.addSubview(settingButton)
        setConstraintsForSettingButton()
    }
    
    internal func setConstraintsForSettingButton() {
        settingButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: (self.view.bounds.size.width / 17) - 50).isActive = true
        settingButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (self.view.bounds.size.width / 17) + 50).isActive = true
    }
    
    //MARK: add @objc func
    
    @objc func highlightWordsAfterPan(gesture: UIPanGestureRecognizer) {
        
        for label in wordLabelsArray {
            let fingerPoint = gesture.location(in: label)
            
            if label.bounds.contains(fingerPoint) {
                label.textColor = model.textColor
            }
        }
    }
    
    @objc func tapForGoToNextScreen(gesture: UITapGestureRecognizer) {
        guard portraitOrientation else { return }
        myTimer.invalidate()
        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: false)
    }
    
    @objc func forTimer() {
        
        countOfSeconds += period
        model.generateStringTime()
        whatLabelsMustLight()
        
        if countOfSeconds % 2 == 0 {
            wordLabelsArray[model.IndexOfecondsDivision].textColor = model.textColor
        } else {
            wordLabelsArray[model.IndexOfecondsDivision].textColor = .darkGray
        }
    }

    @objc func pushSettingButton() {
        guard portraitOrientation else { return }
        myTimer.invalidate()
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
}

