//
//  AdventureStore.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/30/21.
//

import Foundation

class AdventureStore {
    
    let adventureURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("adventure.plist")
    
    func saveAdventure(adventure: Adventure) {
        var adventures = getAdventures()
        adventures.append(adventure)
        
        saveAdventuresToPlist(adventures: adventures)
    }
    
    func editAdventure(adventure: Adventure) {
        var adventures = getAdventures()
        for (i, adv) in adventures.enumerated() {
            if adv.adventureId == adventure.adventureId  {
                adventures.remove(at: i)
                adventures.insert(adventure, at: i)
            }
        }
        saveAdventuresToPlist(adventures: adventures)
    }
    
    func deleteAdventure(adventure: Adventure) {
        var adventures = getAdventures()
        for (i, adv) in adventures.enumerated() {
            if adv.adventureId == adventure.adventureId  {
                adventures.remove(at: i)
            }
        }
        saveAdventuresToPlist(adventures: adventures)
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
    
    func saveAdventuresToPlist(adventures: [Adventure]) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        if let data = try? encoder.encode(adventures) {
            if FileManager.default.fileExists(atPath: adventureURL.path) {
                try? data.write(to: adventureURL)
            } else {
                FileManager.default.createFile(atPath: adventureURL.path, contents: data, attributes: nil)
            }
        }
    }
}
