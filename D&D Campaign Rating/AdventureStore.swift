//
//  AdventureStore.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/30/21.
//

import Foundation

class AdventureStore {
    
    let adventureURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("adventure.plist")
    
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
    
    func editAdventure(adventure: Adventure) {
        var adventures = getAdventures()
        for (i, adv) in adventures.enumerated() {
            if adv.adventureID == adventure.adventureID  {
                adventures.remove(at: i)
                adventures.insert(adventure, at: i)
            }
        }
    }
}
