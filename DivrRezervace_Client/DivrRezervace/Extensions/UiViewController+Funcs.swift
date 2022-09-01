//
//  UiViewController+Alert.swift
//  BackpackConfigurator
//
//  Created by Vojtěch Srb on 20/09/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func getCurrentDateTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: now)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Warning", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func changePlayerNumber(playerNumber: String, selectedSlots: [IndexPath?], slotsCellView: UICollectionView) {
        
        let slots:[IndexPath] = selectedSlots as! [IndexPath]
        
        // guard empty array
        guard  slots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        for i in 0...slots.count - 1
        {
            // change number to 1
            let customCell = slotsCellView.cellForItem(at: slots[i]) as! MyCollectionViewCell
            customCell.playerNumber.text = playerNumber
                        
            if customCell.gameLang.image != nil && customCell.oldColor != UIColor.lightGray
            {
                // deselect items
                slotsCellView.deselectItem(at: slots[i], animated: true)
            }
            else {
                // DO NOTHING
            }
        }
    }
    
    func changeGameLang(selectFlag: String, selectedSlots: [IndexPath?], slotsCellView: UICollectionView) {
        
        let slots:[IndexPath] = selectedSlots as! [IndexPath]
        
        // guard empty array
        guard  slots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        for i in 0...slots.count - 1
        {
            // change game language to czech
            let customCell = slotsCellView.cellForItem(at: slots[i]) as! MyCollectionViewCell
            
            if customCell.playerNumber.text != "" {
                    // deselect items
                    customCell.gameLang.image = UIImage(named: selectFlag)
                }
                else { // DO NOTHING
            }
        }
    }
    
    func changeGameColor(selectColor: UIColor, selectedSlots: [IndexPath?], slotsCellView: UICollectionView) {
        
        let slots:[IndexPath] = selectedSlots as! [IndexPath]
               
               // guard empty array
               guard  slots.count > 0 else {
                   showAlert(message: "No Slot(s) Selected")
                   return
               }
               
               for i in 0...slots.count - 1
               {
                // change game color
                let customCell = slotsCellView.cellForItem(at: slots[i]) as! MyCollectionViewCell
                
                if customCell.gameLang.image != nil && customCell.playerNumber.text != "" {
                    // deselect items
                    customCell.oldColor = selectColor
                    customCell.backgroundColor = selectColor
                    slotsCellView.deselectItem(at: slots[i], animated: true)
                }
                else {
                    showAlert(message: "No language selected!")
            }
        }
    }
    
    func blockSlot(selectColor: UIColor, selectedSlots: [IndexPath?], slotsCellView: UICollectionView) {
        
        let slots:[IndexPath] = selectedSlots as! [IndexPath]
               
               // guard empty array
               guard  slots.count > 0 else {
                   showAlert(message: "No Slot(s) Selected")
                   return
               }
               
               for i in 0...slots.count - 1
               {
                // change game color
                let customCell = slotsCellView.cellForItem(at: slots[i]) as! MyCollectionViewCell
                
                if customCell.gameLang.image == nil && customCell.playerNumber.text == "" {
                    // deselect items
                    customCell.oldColor = selectColor
                    customCell.backgroundColor = selectColor
                    slotsCellView.deselectItem(at: slots[i], animated: true)
                }
                else {
                    showAlert(message: "Slot already registered!")
            }
        }
    }
}

