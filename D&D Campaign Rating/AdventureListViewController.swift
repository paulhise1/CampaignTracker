//
//  AdventureListViewController.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/25/21.
//

import UIKit

struct Adventure: Codable {
    let campaignTitle: String
    let adventureStory: String
    let characterName: String
    let characterType: String
    let note: String
    let rating: Float
    let playDateText: String
    let adventureID: String
}

class AdventureListViewController: UIViewController, InputFormDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adventureTableView: UITableView!
    @IBOutlet weak var addNewButton: UIButton!
    
    var selectedAdventure: Adventure?
    let adventureStore = AdventureStore()
    let adventureURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("adventure.plist")
    let adventureCellId = "adventureCell"
    let recordAdventureSegue = "recordAdventureSegue"
    let detailSegue = "detailSegue"
        
    override func viewDidLoad() {
        super.viewDidLoad()
       configureTableView()
    }
    
    @IBAction func addNewButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: recordAdventureSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue {
            guard let adventure = selectedAdventure else {
                return
            }
            guard let destinationVC = segue.destination as? AdventureDetailViewController else {
                return
            }
            destinationVC.configure(adventure: adventure)
        } else if segue.identifier == recordAdventureSegue {
            let destinationVC = segue.destination as? AdventureInputFormViewController
            destinationVC?.delegate = self
        }
        
    }

    func logAdventure(adventure: Adventure) {
        adventureStore.saveAdventureToPlist(adventureURL: adventureURL, adventure: adventure)
        adventureTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = adventureStore.getAdventures(adventureURL: adventureURL).count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = adventureTableView.dequeueReusableCell(withIdentifier: adventureCellId, for: indexPath) as? AdventureCell else {
            return UITableViewCell()
        }
        let adventure = adventureStore.getAdventures(adventureURL: adventureURL)[indexPath.row]
        cell.configure(dateText: adventure.playDateText, adventure: adventure.adventureStory)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAdventure = adventureStore.getAdventures(adventureURL: adventureURL)[indexPath.row]
        performSegue(withIdentifier: detailSegue , sender: self)
    }
    
    func configureTableView() {
        let xib = UINib(nibName: "AdventureCell", bundle: nil)
        adventureTableView.register(xib, forCellReuseIdentifier: adventureCellId)
        adventureTableView.dataSource = self
        adventureTableView.delegate = self
        
      
    }
}



