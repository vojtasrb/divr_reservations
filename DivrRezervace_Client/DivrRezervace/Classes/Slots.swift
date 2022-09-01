//
//  Slots.swift
//  DivrRezervace
//
//  Created by Vojtěch Srb on 01/03/2020.
//  Copyright © 2020 Vojtěch Srb. All rights reserved.
//

import RealmSwift

class Slots: Object {
  @objc dynamic var time = ""
  @objc dynamic var game = ""
  @objc dynamic var players = ""
  @objc dynamic var lang = ""
  @objc dynamic var status = ""
    
  override static func primaryKey() -> String? {
        return "time"
    }
    
    func newSlot(cell: String, color: String, number: String, lang: String, status: String) -> Slots {
    
        let newSlot = Slots()
        newSlot.time = cell
        newSlot.game = color
        newSlot.players = number
        newSlot.lang = lang
        newSlot.status = status
    
        return newSlot
        
    }
    
    func saveNewSlot(cell: String, color: String, number: String, lang: String, status: String) {
                
        let realm = try! Realm()
            
        let newSlot = self.newSlot(cell: cell, color: color, number: number, lang: lang, status: status)
            
            try! realm.write {
                realm.add(newSlot, update: .modified)
            }
            
        let slots = realm.objects(Slots.self)
        print(slots)
    }
    
    func removeSlot(position: String) {
        let realm = try! Realm()
        let slotToRemove = realm.object(ofType: Slots.self, forPrimaryKey: position)
        
        guard position == "" else {
            print("warning")
            return
        }
        
        try! realm.write {
            realm.delete(slotToRemove!)
        }

    }
    
    func checkmarkSlot(position: String) {
        let realm = try! Realm()
        let slotToUpdate = realm.object(ofType: Slots.self, forPrimaryKey: position)
        
        try! realm.write {
            slotToUpdate?.status = "checkmark"
        }

    }
    
    func deleteAllSlots() {
        let realm = try! Realm()
        let slots = realm.objects(Slots.self)
        
        try! realm.write {
            realm.deleteAll()
        }
        
        print(slots)
    }
    
    func refreshSlots(collectionView: UICollectionView) {
        
        let realm = try! Realm()
        let slots = realm.objects(Slots.self)
        
        guard !realm.isEmpty else {
            print("empty")
            return
        }
        
        for i in 0...slots.count - 1
        {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: items.firstIndex(of: slots[i].time)!, section: 0)
        let customCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        
            customCell.playerNumber.text = slots[i].players
            customCell.gameLang.image = UIImage(named: slots[i].lang)
            customCell.statusImage.image = UIImage(named: slots[i].status)
            
            switch slots[i].game {
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
        }
    }
}
