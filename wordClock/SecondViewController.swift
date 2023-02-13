//
//  SecondViewController.swift
//  wordClock
//
//  Created by Александр Рахимов on 26.11.2022.
//

import UIKit

class SecondViewController: UIViewController {

    let model = Model.model
    let mainAnimator = UIDynamicAnimator()
    var aboutLabels = [UILabel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        createAboutLabels()
        addGesture()
    }

    //MARK: create about labels

    private func createAboutLabels() {

        let sideOfLabel = self.view.bounds.size.width / 12
        var count = 0
        var positionX = self.view.center.x - (sideOfLabel * 4.5)
        var positionY = self.view.center.y - (sideOfLabel * 4)

        for letter in model.aboutString.uppercased() {

            count += 1

            let newLabel = UILabel(frame: CGRect(x: 0, y: 0, width: sideOfLabel, height: sideOfLabel))
            newLabel.center = CGPoint(x: positionX, y: positionY)
            newLabel.text = String(letter)
            newLabel.textAlignment = .center
            newLabel.textColor = model.textColor
            newLabel.font = UIFont.init(name: "Courier", size: 25)
            newLabel.backgroundColor = self.view.backgroundColor
            aboutLabels.append(newLabel)
            self.view.addSubview(newLabel)

            positionX += sideOfLabel
            if count == 10 {
                positionY += sideOfLabel * 2
                positionX = self.view.center.x - (sideOfLabel * 4.5)
            } else if count == 20 {
                positionY += sideOfLabel * 2
                positionX = self.view.center.x - (sideOfLabel * 3)
            }  else if count == 27 {
                    positionY += sideOfLabel * 2
                    positionX = self.view.center.x - (sideOfLabel * 5)
            } else if count == 38 {
                positionY += sideOfLabel * 2
                positionX = self.view.center.x - (sideOfLabel * 4)
            }
        }
    }

    //MARK: add gesture
    private func addGesture() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(createAnimation))
        self.view.addGestureRecognizer(gesture)
    }



    //MARK: create animation

    @objc func createAnimation() {

        model.tapCountForAboutScreen += 1

        let labelBehavior = UIDynamicItemBehavior(items: aboutLabels)
        for label in aboutLabels {
            let randomFloat = Float.random(in: 1...3)
            labelBehavior.addAngularVelocity(CGFloat(randomFloat), for: label)
        }
        mainAnimator.addBehavior(labelBehavior)

        if model.tapCountForAboutScreen == 2 {

            let gravity = UIGravityBehavior(items: aboutLabels)
            gravity.magnitude = 0.5
            mainAnimator.addBehavior(gravity)

            //MARK: POP
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [self] in

                self.navigationController?.popViewController(animated: false)
                model.tapCountForAboutScreen = 0
            })
        }
    }
}
