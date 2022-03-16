////
////  LibraryModels.swift
////  Radom
////
////  Created by Javier Contreras on 3/14/22.
////
//
//import QuickLookThumbnailing
//import SwiftUI
//import Combine
//import UIKit
//
//
//class ThumbnailGenerator: ObservableObject {
//    @Published var thumbnailImage: UIImage?
//
//    func generateThumbnail(for resource: String, withExtension: String = "usdz", size: CGSize) {
//
//        guard let url = Bundle.main.url(forResource: resource, withExtension: withExtension) else {
//            print("Unable to create url for resource")
//            return
//        }
//
//        let scale = UIScreen.main.scale
//
//        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
//
//        let generator = QLThumbnailGenerator.shared
//
//        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
//            DispatchQueue.main.async {
//                if thumbnail == nil || error != nil {
//                    print("error generating thumbnail: \(error?.localizedDescription)")
//                    return
//                } else {
//                    self.thumbnailImage = thumbnail!.uiImage
//                }
//            }
//        }
//    }
//}


import Foundation
import SceneKit
import SceneKit.ModelIO

class ARQLThumbnailGenerator {
    private let device = MTLCreateSystemDefaultDevice()!

    /// Create a thumbnail image of the asset with the specified URL at the specified
    /// animation time. Supports loading of .scn, .usd, .usdz, .obj, and .abc files,
    /// and other formats supported by ModelIO.
    /// - Parameters:
    ///     - url: The file URL of the asset.
    ///     - size: The size (in points) at which to render the asset.
    ///     - time: The animation time to which the asset should be advanced before snapshotting.
    func thumbnail(for url: URL, size: CGSize, time: TimeInterval = 0) -> UIImage? {
        let renderer = SCNRenderer(device: device, options: [:])
        renderer.autoenablesDefaultLighting = true

        if (url.pathExtension == "scn") {
            let scene = try? SCNScene(url: url, options: nil)
            renderer.scene = scene
        } else {
            let asset = MDLAsset(url: url)
            let scene = SCNScene(mdlAsset: asset)
            renderer.scene = scene
        }

        let image = renderer.snapshot(atTime: time, with: size, antialiasingMode: .multisampling4X)
        return image
    }
}
