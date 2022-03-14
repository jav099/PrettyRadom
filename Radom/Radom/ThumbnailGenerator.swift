//
//  LibraryModels.swift
//  Radom
//
//  Created by Javier Contreras on 3/14/22.
//

import QuickLookThumbnailing
import SwiftUI
import Combine
import UIKit


class ThumbnailGenerator: ObservableObject {
    @Published var thumbnailImage: UIImage?
    
    func generateThumbnail(for resource: String, withExtension: String = "usdz", size: CGSize) {
        
        guard let url = Bundle.main.url(forResource: resource, withExtension: withExtension) else {
            print("Unable to create url for resource")
            return
        }
        
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
        
        let generator = QLThumbnailGenerator.shared
        
        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    print("error generating thumbnail: \(error?.localizedDescription)")
                    return
                } else {
                    self.thumbnailImage = thumbnail!.uiImage
                }
            }
        }
    }
}
