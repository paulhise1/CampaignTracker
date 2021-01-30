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
}

class AdventureListViewController: UIViewController, InputFormDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adventureListTableView: UITableView!
    @IBOutlet weak var addNewButton: UIButton!
    
    let adventureURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("adventure.plist")
    let adventureCellId = "adventureCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configureTableView()
    }
    
    @IBAction func addNewButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "recordAdventureSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? AdventureInputFormViewController
        destinationVC?.delegate = self
    }

    func logAdventure(adventure: Adventure) {
      saveAdventureToPlist(adventure: adventure)
    }
    
    func getAdventures() -> [Adventure] {
        let decoder = PropertyListDecoder()
        print(adventureURL)
        guard let data = try? Data(contentsOf: adventureURL),
              let adventures = try? decoder.decode([Adventure].self, from: data) else {
        return []
        }
        return adventures
    }
    
    func saveAdventureToPlist(adventure: Adventure) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
       
        var adventures = getAdventures()
        adventures.append(adventure)
        
        if let data = try? encoder.encode(adventures) {
            if FileManager.default.fileExists(atPath: adventureURL.path) {
                try? data.write(to: adventureURL)
            } else {
                FileManager.default.createFile(atPath: adventureURL.path, contents: data, attributes: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAdventures().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: adventureCellId) as! AdventureTableViewCell
        let date = String(describing: Date())
        let adventure = getAdventures()[indexPath.row]
        cell.dateLabel.text = date
        cell.adventureLabel.text = adventure.adventureStory
//        cell?.configure(date: date, adventureName: adventure.adventureStory)
        return cell
    }
    
    func configureTableView() {
       
        adventureListTabelView.register(AdventureTableViewCell.self, forCellReuseIdentifier: adventureCellId)
        adventureListTabelView.dataSource = self
        adventureListTabelView.delegate = self
    }
}

