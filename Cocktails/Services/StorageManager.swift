//
//  StorageManager.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 27.07.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults()
    private let key = "day"
    
    private init() {}
    
    func getTodayTop(completion: @escaping (_ top: [Int]) -> Void) {
        if let dayTop = getTop() {
            if Calendar.current.isDateInToday(dayTop.date) {
                let top = dayTop.id
                completion(top)
            } else {
                NetworkManager.shared.fetchIds { ids in
                    self.setTop(id: ids)
                    completion(ids)
                }
            }
        } else {
            NetworkManager.shared.fetchIds { ids in
                self.setTop(id: ids)
                completion(ids)
            }
        }
    }
    
    private func getTop() -> DayTop? {
        guard let dayTopData = userDefaults.object(forKey: key) as? Data else { return nil }
        do {
            let dayTop = try PropertyListDecoder().decode(DayTop.self, from: dayTopData)
            return dayTop
        } catch {
            print(error)
        }
        return nil
    }
    
    private func setTop(id: [Int]) {
        let dayTop = DayTop(date: Date.now, id: id)
        do {
            let dayTopData = try PropertyListEncoder().encode(dayTop)
            userDefaults.set(dayTopData, forKey: key)
        } catch {
            print(error)
        }
    }
}
