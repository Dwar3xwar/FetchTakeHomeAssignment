import Foundation
import SwiftUI

protocol IRecipeCacheService {
    func add(image: UIImage, id: String) async
    func remove(id: String) async
    func get(id: String) async -> UIImage? 
}

actor RecipeCacheService: IRecipeCacheService {
    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func add(image: UIImage, id: String) {
        cache.setObject(image, forKey: id as NSString)
    }
    
    func remove(id: String) {
        cache.removeObject(forKey: id as NSString)
    }
    
    func get(id: String) -> UIImage? {
        return cache.object(forKey: id as NSString)
    }
}
