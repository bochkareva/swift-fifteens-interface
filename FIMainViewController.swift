//
//  CollectionViewController.swift
//  FifteensInterface
//
//  Created by bochkareva on 05/12/2018.
//  Copyright © 2018 bochkareva. All rights reserved.
//

import UIKit

class FIMainViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var randomize: UIButton!
    
    @IBOutlet var background: [UIImageView]!
    
    var buttonsOrder = [Int]()
    
    let fieldSize = 4
    
    var moveStarted = false
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    let screenHeight = UIScreen.main.bounds.size.height
    
    let colorForAlert = #colorLiteral(red: 1, green: 0.5607843399, blue: 0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "background.jpg") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        for index in 0...15 {
            buttonsOrder.append(index)
        }
        var index = 0
        for button in self.buttons {
            button.layer.cornerRadius = 5;
            button.clipsToBounds = true;
            if (index != 0) {
                button.setTitle("\(index)", for: .normal)
                button.frame = CGRect(x: (Int)(screenWidth*0.055) + (Int)(screenWidth*0.23)*((index-1)%4), y: (Int)(screenHeight*0.2) + (Int)(screenWidth*0.23)*((index-1)/4), width: (Int)(screenWidth*0.2) , height: (Int)(screenWidth*0.2))
            }
            else {
                button.frame = CGRect(x: (Int)(screenWidth*0.055) + (Int)(screenWidth*0.23)*((index+15)%4), y: (Int)(screenHeight*0.2) + (Int)(screenWidth*0.23)*((index+15)/4), width: (Int)(screenWidth*0.2) , height: (Int)(screenWidth*0.2))
            }
            index += 1
        }
        randomize.layer.cornerRadius = 5;
        randomize.clipsToBounds = true;
        randomize.frame = CGRect(x: (Int)(screenWidth*0.3), y: (Int)(screenHeight*0.8) , width: (Int)(screenWidth*0.4) , height: (Int)(screenHeight*0.06))
    }
    
    @IBAction func moveButtonPressed(_ sender: UIButton){
        if (self.moveStarted){
            let pressedButtonIndex = self.buttons.firstIndex(of: sender) ?? 0
            let pressedButtonPlace = self.buttonsOrder.firstIndex(of: pressedButtonIndex) ?? 0
            let emptyButtonPlace = self.buttonsOrder.firstIndex(of: 0) ?? 0
            
            if (movePossible(pressedPlace: pressedButtonPlace, emptyPlace: emptyButtonPlace)){
                self.buttonsOrder.swapAt(pressedButtonPlace, emptyButtonPlace)
                 UIView.animate(withDuration: 0.7) {
                    let tempFrame = self.buttons[pressedButtonIndex].frame
                    self.buttons[pressedButtonIndex].frame = self.buttons[0].frame
                    self.buttons[0].frame = tempFrame
                }
                
                if (victory()){
                  self.displayAlert()
                }
            }
        }
    }
    
    func displayAlert(){
        let alertController : UIAlertController = UIAlertController(title: "YOU ARE WINNER", message: "Congratulations! ", preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        alertController.view.tintColor = colorForAlert
        self.present(alertController, animated: true)
    }
    
    @IBAction func randomize(_ sender: Any) {
        self.buttonsOrder.shuffle()
        while (!solutionExists(cells:buttonsOrder)){
        self.buttonsOrder.shuffle()
        }
        UIView.animate(withDuration: 0.5) {
            for index in 0...15 {
                let newIndex = self.buttonsOrder[index] as Int
                let button = self.buttons[newIndex]
                  button.frame = CGRect(x: (Int)(self.screenWidth*0.055) + (Int)(self.screenWidth*0.23)*(index%4), y: (Int)(self.screenHeight*0.2) + (Int)(self.screenWidth*0.23)*(index/4), width: (Int)(self.screenWidth*0.2) , height: (Int)(self.screenWidth*0.2))
            }
        }
        self.moveStarted = true;
    }
    
    func solutionExists (cells: [Int])->Bool{
        var inv = 0
        for i in 1...cells.count-1{
                if (cells[i] != 0){
                    for j in 0...i - 1{
                        if (cells[j] > cells[i]){
                            inv += 1
                        }
                    }
                }
            }
            for i in 0...cells.count-1{
                if (cells[i] == 0){
                    inv += 1 + i/fieldSize
                }
            }
            return (inv%2 == 0)
        }
    
    func movePossible(pressedPlace: Int, emptyPlace: Int)->Bool{
        let leftBorder = (emptyPlace%4-1 >= 0)
        let rightBorder = (emptyPlace%4+1 <= fieldSize-1)
        let upperBorder = (emptyPlace/4-1 >= 0)
        let bottomBorder = (emptyPlace/4+1 <= fieldSize-1)
        
        return ((leftBorder && (emptyPlace - 1 == pressedPlace)) ||
            (rightBorder && (emptyPlace + 1 == pressedPlace)) ||
            (upperBorder && (emptyPlace%4 + (emptyPlace/4 - 1) * 4 == pressedPlace) ||
            (bottomBorder && (emptyPlace%4 + (emptyPlace/4 + 1) * 4 == pressedPlace))))
    }
    
    func victory()->Bool{
        var victoryCondition = true
        if (buttonsOrder[15] != 0){
            return false
        }
        for i in 0...fieldSize-1 {
            for j in 0...fieldSize-1 {
                if (((i != fieldSize-1)||(j != fieldSize-1)) && (buttonsOrder[i*4 + j] != (j + i*fieldSize + 1))){
                    victoryCondition = false
                    break
                }
            }
        }
      return victoryCondition
    }
}
