//
//  ViewController.swift
//  DivrRezervace
//
//  Created by Vojtěch Srb on 16/09/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import UIKit

var items = ["10:00", "10:05", "10:10", "10:15", "10:20", "10:25", "10:30", "10:35", "10:40", "10:45", "10:50", "10:55", "11:00", "11:05", "11:10", "11:15", "11:20", "11:25", "11:30", "11:35",
   "11:40", "11:45", "11:50", "11:55", "12:00", "12:05", "12:10", "12:15", "12:20", "12:25",
   "12:30", "12:35", "12:40", "12:45", "12:50", "12:55", "13:00", "13:05", "13:10", "13:15",
   "13:20", "13:25", "13:30", "13:35", "13:40", "13:45", "13:50", "13:55", "14:00", "14:05",
   "14:10", "14:15", "14:20", "14:25", "14:30", "14:35", "14:40", "14:45", "14:50", "14:55",
   "15:00", "15:05", "15:10", "15:15", "15:20", "15:25", "15:30", "15:35", "15:40", "15:45",
   "15:50", "15:55", "16:00", "16:05", "16:10", "16:15", "16:20", "16:25", "16:30", "16:35",
   "16:40", "16:45", "16:50", "16:55", "17:00", "17:05", "17:10", "17:15", "17:20", "17:25",
   "17:30", "17:35", "17:40", "17:45", "17:50", "17:55", "18:00", "18:05", "18:10", "18:15",
   "18:20", "18:25", "18:30", "18:35", "18:40", "18:45", "18:50", "18:55", "19:00", "19:05",
   "19:10", "19:15", "19:20", "19:25", "19:30", "19:35", "19:40", "19:45", "19:50", "19:55"]

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var selectedSlots:[IndexPath?] = []
    
    @IBOutlet weak var slotsCellView: UICollectionView!

    @IBOutlet weak var playerOneBtn: UIButton!
    @IBOutlet weak var playerTwoBtn: UIButton!
    @IBOutlet weak var playerThreeBtn: UIButton!
    @IBOutlet weak var playerFourBtn: UIButton!
    @IBOutlet weak var czechFlagBtn: UIButton!
    @IBOutlet weak var engFlagBtn: UIButton!
    @IBOutlet weak var golemBtn: UIButton!
    @IBOutlet weak var spiderBtn: UIButton!
    @IBOutlet weak var blockedBtn: UIButton!
    @IBOutlet weak var deleteAllBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.allowsMultipleSelection = true
        return items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = items[indexPath.item]
        cell.backgroundColor = UIColor.lightGray
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(sender:)))
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(gesture:)))
        
        rightSwipe.direction = .right
        
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.allowableMovement = 15 // 15 points
        longPressGesture.delegate = self
        
        doubleTapGesture.numberOfTapsRequired = 2  // add double tap
        
        self.slotsCellView.addGestureRecognizer(longPressGesture)
        self.slotsCellView.addGestureRecognizer(rightSwipe)
        self.slotsCellView.addGestureRecognizer(doubleTapGesture)
        
        DispatchQueue.global(qos: .utility).async {
              Network().udpServer(collectionView: self.slotsCellView)
          }
          
          _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) {
              timer in
              DispatchQueue.main.async {
              
              for i in 0...items.count - 1
              {
                  print(self.getCurrentDateTime())
                  
                  let indexPath = IndexPath(item: i, section: 0)
                  let customCell = self.slotsCellView.cellForItem(at: indexPath) as! MyCollectionViewCell
                  
                  let datenow = self.getCurrentDateTime()
                  let formatter4 = DateFormatter()
                  formatter4.dateFormat = "HH:mm"
                  
                  if formatter4.date(from: customCell.myLabel.text ?? "00:00")! <= formatter4.date(from: datenow )! {
                      customCell.alpha = 0.5
              }
            }
          }
        }
    }
    
    // MARK: - UICollectionViewGestures protocol
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizer.State.ended {
            return
        }
        else if sender.state == UIGestureRecognizer.State.began
        {
            let p = sender.location(in: self.slotsCellView)
            let indexPath = self.slotsCellView.indexPathForItem(at: p)
            
            guard indexPath != nil else {
                showAlert(message: "No Slot(s) Selected")
                return
            }
            
            let customCell = slotsCellView.cellForItem(at: indexPath!) as! MyCollectionViewCell
            
            customCell.playerNumber.text = ""
            customCell.gameLang.image = nil
            customCell.backgroundColor = UIColor.lightGray
            customCell.statusImage.image = nil
            
            Slots().removeSlot(position: customCell.myLabel.text!)
            
            Network().sendSlots(cell: customCell.myLabel.text!, color: "lightGray", number: customCell.playerNumber.text!, lang: "", status: "")
        }
    }
    
    @objc func rightSwipe(sender: UISwipeGestureRecognizer)
    {
         if (sender.direction == .right) {
            
            // guard empty array
            guard  selectedSlots.count > 0 else {
                showAlert(message: "No Slot(s) Selected")
                return
            }

                let firstCell = slotsCellView.cellForItem(at: selectedSlots.first!!) as! MyCollectionViewCell
                
                print(selectedSlots.last!!)
                var postIndex = selectedSlots.last!!
                postIndex.item += 1
                print(postIndex)
                let postCell = slotsCellView.cellForItem(at: postIndex) as! MyCollectionViewCell
                
                postCell.playerNumber.text = firstCell.playerNumber.text
                postCell.gameLang.image = firstCell.gameLang.image
                postCell.backgroundColor = firstCell.oldColor
                postCell.statusImage.image = firstCell.statusImage.image
                
                for i in 0...selectedSlots.count - 1
                {
                    slotsCellView.deselectItem(at: selectedSlots[i]!, animated: true)
                }
            
                firstCell.playerNumber.text = ""
                firstCell.gameLang.image = nil
                firstCell.backgroundColor = UIColor.lightGray
                firstCell.statusImage.image = nil
            
                selectedSlots.removeAll()
            
            Network().sendSlots(cell: postCell.myLabel.text!, color: postCell.selectedGame(), number: postCell.playerNumber.text!, lang: postCell.selectedLang(), status: postCell.selectedStatus())
                
            Network().sendSlots(cell: firstCell.myLabel.text!, color: "lightGray", number: firstCell.playerNumber.text!, lang: "", status: "")
        }
    }
    
    @objc func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        
        // guard empty array
        guard  selectedSlots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        let pointInCollectionView: CGPoint = gesture.location(in: self.slotsCellView)
        let selectedIndexPath: IndexPath = self.slotsCellView.indexPathForItem(at: pointInCollectionView)!

        let customCell = slotsCellView.cellForItem(at: selectedIndexPath) as! MyCollectionViewCell
        
        customCell.statusImage.image = UIImage(named: "checkmark")
        
        Slots().checkmarkSlot(position: customCell.myLabel.text!)
        
        slotsCellView.deselectItem(at: selectedIndexPath, animated: true)
        selectedSlots.removeAll()
        
        // send status to client
        Network().sendSlots(cell: customCell.myLabel.text!, color: customCell.selectedGame(), number: customCell.playerNumber.text!, lang: customCell.selectedLang(), status: customCell.selectedStatus())
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell?.backgroundColor == UIColor.black{
            showAlert(message: "Already registered")
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        else {
            cell?.backgroundColor = UIColor.orange
            
            selectedSlots.append(indexPath)
    }
}
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        print("You deselected cell #\(indexPath.item)!")
        
        // remove from selection once diselected
        if let index = selectedSlots.firstIndex(of: indexPath) {
            selectedSlots.remove(at: index)
        }
    }
    
    // MARK: - IBActions protocol
    
    @IBAction func playerOneBtn(_ sender: Any) {
        
        // change player number
        changePlayerNumber(playerNumber: "1", selectedSlots: selectedSlots, slotsCellView: slotsCellView)
    }
    
    @IBAction func playerTwoBtn(_ sender: Any) {
        
        // change player number
        changePlayerNumber(playerNumber: "2", selectedSlots: selectedSlots, slotsCellView: slotsCellView)
    }
    
    @IBAction func playerThreeBtn(_ sender: Any) {
        
        // change player number
        changePlayerNumber(playerNumber: "3", selectedSlots: selectedSlots, slotsCellView: slotsCellView)
    }
    
    @IBAction func playerFourBtn(_ sender: Any) {
        
        // change player number
        changePlayerNumber(playerNumber: "4", selectedSlots: selectedSlots, slotsCellView: slotsCellView)
    }
    
    @IBAction func czechLangBtn(_ sender: Any) {
        // change player number
        changeGameLang(selectFlag: "czech", selectedSlots: selectedSlots, slotsCellView: slotsCellView)
        
        // guard empty array
        guard  selectedSlots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        let customCell = slotsCellView.cellForItem(at: selectedSlots[0]!) as! MyCollectionViewCell
        
        guard  customCell.playerNumber.text != "" else {
            showAlert(message: "Select number of players first!")
            return
        }
    }
    
    @IBAction func engLangBtn(_ sender: Any) {
        // change player number
        changeGameLang(selectFlag: "eng", selectedSlots: selectedSlots, slotsCellView: slotsCellView)
        
        // guard empty array
        guard  selectedSlots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        let customCell = slotsCellView.cellForItem(at: selectedSlots[0]!) as! MyCollectionViewCell
        
        guard  customCell.playerNumber.text != "" else {
            showAlert(message: "Select number of players first!")
            return
        }
    }
    
    
    @IBAction func golemGameBtn(_ sender: Any) {
        // change game color
        changeGameColor(selectColor: UIColor.brown, selectedSlots: selectedSlots, slotsCellView: slotsCellView)
        
        // guard empty array
        guard  selectedSlots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        let customCell = slotsCellView.cellForItem(at: selectedSlots[0]!) as! MyCollectionViewCell
        
        guard  customCell.playerNumber.text != "" && customCell.gameLang.image != nil else {
            showAlert(message: "Select number of players first!")
            return
        }
                
        for i in 0...selectedSlots.count - 1
        {
            let slotCell = slotsCellView.cellForItem(at: selectedSlots[i]!) as! MyCollectionViewCell
                        
            Slots().saveNewSlot(cell: slotCell.myLabel.text!, color: "brown", number: customCell.playerNumber.text!, lang: customCell.selectedLang(), status: customCell.selectedStatus())
            
            Network().sendSlots(cell: slotCell.myLabel.text!, color: "brown", number: customCell.playerNumber.text!, lang: customCell.selectedLang(), status: customCell.selectedStatus())
        }
        
        // remove from selection
        selectedSlots.removeAll()

    }
    
    @IBAction func spiderGameBtn(_ sender: Any) {
        // change game color
        changeGameColor(selectColor: UIColor.red, selectedSlots: selectedSlots, slotsCellView: slotsCellView)
        
        // guard empty array
        guard  selectedSlots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        let customCell = slotsCellView.cellForItem(at: selectedSlots[0]!) as! MyCollectionViewCell
        
        guard  customCell.playerNumber.text != "" && customCell.gameLang.image != nil else {
            showAlert(message: "Select number of players first!")
            return
        }
        
        for i in 0...selectedSlots.count - 1
        {
            let slotCell = slotsCellView.cellForItem(at: selectedSlots[i]!) as! MyCollectionViewCell
            
            Slots().saveNewSlot(cell: slotCell.myLabel.text!, color: "red", number: customCell.playerNumber.text!, lang: customCell.selectedLang(), status: customCell.selectedStatus())
            
            Network().sendSlots(cell: slotCell.myLabel.text!, color: "red", number: customCell.playerNumber.text!, lang: customCell.selectedLang(), status: customCell.selectedStatus())
        }
        
        // remove from selection
        selectedSlots.removeAll()
    }
    
    @IBAction func blockSlotBtn(_ sender: Any) {
        // guard empty array
        guard  selectedSlots.count > 0 else {
            showAlert(message: "No Slot(s) Selected")
            return
        }
        
        let customCell = slotsCellView.cellForItem(at: selectedSlots[0]!) as! MyCollectionViewCell
        
        guard  customCell.playerNumber.text == "" && customCell.gameLang.image == nil else {
            showAlert(message: "Already registered!")
            return
        }
        
        // change game color
        blockSlot(selectColor: UIColor.black, selectedSlots: selectedSlots, slotsCellView: slotsCellView)
        
        for i in 0...selectedSlots.count - 1
        {
            let slotCell = slotsCellView.cellForItem(at: selectedSlots[i]!) as! MyCollectionViewCell
            
            Slots().saveNewSlot(cell: slotCell.myLabel.text!, color: "black", number: "", lang: "", status: customCell.selectedStatus())
            
            Network().sendSlots(cell: slotCell.myLabel.text!, color: "black", number: "", lang: "", status: customCell.selectedStatus())
        }
                
        // remove from selection
        selectedSlots.removeAll()
    }
    
    @IBAction func deleteAllSlots(_ sender: Any) {
        Slots().deleteAllSlots()
    }
    
    @IBAction func refreshSlots(_ sender: Any) {
        Slots().refreshSlots(collectionView: slotsCellView)
    }
}

