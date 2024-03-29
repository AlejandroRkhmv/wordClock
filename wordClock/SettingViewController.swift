//
//  SettingViewController.swift
//  wordClock
//
//  Created by Александр Рахимов on 26.11.2022.
//

import UIKit

class SettingViewController: UIViewController {

    let model = Model.model
    
    var labels = [UILabel]()
    var textColorView = [UIView]()
    let textColorArray = [UIColor.white, UIColor.red, UIColor.orange, UIColor.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).supportedInterfaceOrientationsFor = .portrait
        createLabel(x: Int(self.view.center.x), y: Int(self.view.bounds.size.height * 0.25), text: "CHOOSE TEXT COLOR")
        
        createTextColorView()
    }
  
    //MARK: create labels
    
    private func createLabel(x: Int, y: Int, text: String) {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        label.center = CGPoint(x: x, y: y)
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.init(name: "Courier", size: 25)
        labels.append(label)
        self.view.addSubview(label)
    }

    //MARK: create color views
    
    private func createTextColorView() {
        
        let sideOfColorView = self.view.bounds.size.width / 10
        
        var positionX = self.view.center.x - (sideOfColorView * 2.25)
        let betweenColors = sideOfColorView / 2
        
        for (index, value) in textColorArray.enumerated() {
            
            let colorView = UIView(frame: CGRect(x: 0, y: 0, width: sideOfColorView, height: sideOfColorView))
            colorView.center = CGPoint(x: Int(positionX), y: Int(self.view.bounds.size.height * 0.35))
            colorView.backgroundColor = value
            colorView.layer.cornerRadius = 5
            colorView.layer.borderWidth = 2
            colorView.layer.borderColor = UIColor.lightGray.cgColor
            colorView.tag = index
            textColorView.append(colorView)
            self.view .addSubview(colorView)
            positionX += sideOfColorView + betweenColors
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextColor(gesture:)))
            colorView.addGestureRecognizer(tapGesture)
        }
        
        positionX = self.view.center.x - (sideOfColorView / 2)
    }
    
    //MARK: create objc func for gestures
    
    @objc func tapTextColor(gesture: UITapGestureRecognizer) {
        
        for value in textColorView {
            if value.tag == gesture.view?.tag {
                if let color = value.backgroundColor {
                    clearUserDefaults()
                    model.textColor = color
                    navigationController?.popViewController(animated: false)
                }
            }
        }
    }
    
    // MARK: - clear User Defaults before set new color
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: KeysColor.red.rawValue)
        UserDefaults.standard.removeObject(forKey: KeysColor.green.rawValue)
        UserDefaults.standard.removeObject(forKey: KeysColor.blue.rawValue)
        UserDefaults.standard.removeObject(forKey: KeysColor.alpha.rawValue)
    }
}
