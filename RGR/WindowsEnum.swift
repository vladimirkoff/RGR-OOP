
import UIKit

enum Windows {
    case textField
    case customView
    case gallery
    case submit
    case alert
    case dialog
    
    var image: UIImage? {
        switch self {
        case .textField:
            return UIImage(systemName: "textformat.size")
        case .customView:
            return UIImage(systemName: "pencil")
        case .gallery:
            return UIImage(systemName: "photo.fill")
        case .submit:
            return UIImage(systemName: "checkmark")
        case .alert:
            return UIImage(systemName: "square.and.pencil")
        case .dialog:
            return UIImage(systemName: "list.bullet")
        }
    }
}
