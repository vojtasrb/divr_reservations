//
//  Network.swift
//  DivrRezervace
//
//  Created by Vojtěch Srb on 21/09/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import Foundation
import FGRoute
import SwiftSocket
import SwiftyJSON
import SwiftySound

class Network {
    
    func sendSlots(cell: String, color: String, number: String, lang: String, status: String)
    {
        let messageDictionary = [
        "time": cell,
        "game": color,
        "players": number,
        "lang": lang,
        "status": status]
        as [String : Any]

        //let slotJSON = JSON(messageDictionary)
        
        //let name = slotJSON["time"].stringValue
        //print(name)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary)
        //let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        
        let client = UDPClient(address: "10.46.4.250", port: 1660)
        _ = client.send(data: jsonData)
        
        print(messageDictionary)
    }
    
    func udpServer(collectionView: UICollectionView)
    {
        let server = UDPServer(address: FGRoute.getIPAddress(), port: 1660)
        
        while true {
            // received message from clients
            let(byteArray, senderIPAddress, senderPort) = server.recv(1024)
            
            if let byteArray = byteArray,
                let slotData = String(data: Data(byteArray), encoding: .utf8)
            {
                print("Client received: \(slotData)\nsender: \(senderIPAddress)\nport: \(senderPort)")
                
                if slotData == "RequestSlots" {
                    for i in 0...items.count - 1
                    {
                        DispatchQueue.main.async {
                    let indexPath = IndexPath(row: i, section: 0)
                    let customCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
                        
                        if customCell.backgroundColor == UIColor.lightGray {
                            // DO NOTHING
                        }
                        else {
                            self.sendSlots(cell: customCell.myLabel.text!,color: customCell.selectedGame(),number: customCell.playerNumber.text!,lang: customCell.selectedLang(),status: customCell.selectedStatus())
                            }
                        }
                    }
                }
                else {
                
                let dict = ViewController().convertToDictionary(text: slotData)
                let slotJSON = JSON(dict!)
                        
                let cell = slotJSON["time"].stringValue
                let color = slotJSON["game"].stringValue
                let number = slotJSON["players"].stringValue
                let lang = slotJSON["lang"].stringValue
                let status = slotJSON["status"].stringValue

                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: items.firstIndex(of: cell)!, section: 0)
                    let customCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
                    
                        customCell.playerNumber.text = number
                        customCell.gameLang.image = UIImage(named: lang)
                        customCell.statusImage.image = UIImage(named: status)
                        
                        switch color {
                        case "red":
                            customCell.backgroundColor = UIColor.red
                            break
                        case "brown":
                            customCell.backgroundColor = UIColor.brown
                            break
                        case "black":
                            customCell.backgroundColor = UIColor.black
                            break
                        case "lightGray":
                            customCell.backgroundColor = UIColor.lightGray
                            break
                        default:
                            print("no color")
                        }
                    }
                
                print(cell,color,number,lang,status)
                    Sound.stopAll()
                    Sound.play(file: "notification.wav")
                
                }
            }
        }
    }
}
