

import UIKit

final class DataManager {
    
    private let pickerData = [
        WindowModel(name: "Alert", type: .alert),
        WindowModel(name: "Submit", type: .submit),
        WindowModel(name: "TextField", type: .textField),
        WindowModel(name: "Gallery", type: .gallery),
        WindowModel(name: "Custom", type: .customView),
        WindowModel(name: "Dialog", type: .dialog),
    ]
    
    private let images: [UIImage?] = [
        UIImage(systemName: "dollarsign.square.fill"),
        UIImage(systemName: "homekit"),
        UIImage(systemName: "apple.logo"),
        UIImage(systemName: "appletv.fill"),
        UIImage(systemName: "display"),
        UIImage(systemName: "globe.americas.fill"),
        UIImage(systemName: "signature"),
        UIImage(systemName: "airplane"),
        UIImage(systemName: "bolt.fill"),
        UIImage(systemName: "folder.fill"),
    ]
    
    static var shared = DataManager()
    private init() {}
    
    func getPickerData() -> [WindowModel] {
        return pickerData
    }
    
    func getImages() -> [UIImage?] {
        return images
    }
}
