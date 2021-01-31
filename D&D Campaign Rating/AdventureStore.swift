//
//  AdventureStore.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/30/21.
//

import Foundation

class AdventureStore {
    
    func getAdventures(adventureURL: URL) -> [Adventure] {
        let decoder = PropertyListDecoder()
        print(adventureURL)
        guard let data = try? Data(contentsOf: adventureURL),
              let adventures = try? decoder.decode([Adventure].self, from: data) else {
        return []
        }
        return adventures
    }
    
    func saveAdventureToPlist(adventureURL: URL, adventure: Adventure) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
       
        var adventures = getAdventures(adventureURL: adventureURL)
        adventures.append(adventure)
        
        if let data = try? encoder.encode(adventures) {
            if FileManager.default.fileExists(atPath: adventureURL.path) {
                try? data.write(to: adventureURL)
            } else {
                FileManager.default.createFile(atPath: adventureURL.path, contents: data, attributes: nil)
            }
        }
    }
}
