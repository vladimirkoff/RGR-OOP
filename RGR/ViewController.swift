
import UIKit
import Windows
import PhotosUI

final class ViewController: UIViewController {
    
    typealias AlertActionClosure = (UIAlertAction) -> ()
    
    // MARK: UI Properties
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.isHidden = true
        return label
    }()
    
    private let currentImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        iv.isHidden = true
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    private let customCollectionView: CustomViewWithHorizontalCollection = {
        let collectionView = CustomViewWithHorizontalCollection()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounds = CGRect(x: 0, y: 0, width: 0, height: 250)
        return collectionView
    }()
    
    private let customImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        iv.bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        return iv
    }()
    
    // MARK: Closures
    
    private var option1Closure: AlertActionClosure {
        return { action in
            print("Option 1")
        }
    }
    
    private var option2Closure: AlertActionClosure {
        return { action in
            print("Option 2")
        }
    }
    
    private var option3Closure: AlertActionClosure {
        return { action in
            print("Option 3")
        }
    }
    
    // MARK: Windows
    
    private var currentWindow: Window? {
        didSet {
            currentWindow!.createAlert()
            currentWindow!.presentWindow(self, animated: true)
        }
    }
    
    private let alertWindow = AlertWindow(title: "Alert Window", message: "Alert Window Message")
    private lazy var dialogWindow = DialogWindow(title: "Dialog Window",
                                            message: "Dialog Window Message",
                                            options: ["Option 1", "Option 2", "Option 3"],
                                            actions: [option1Closure, option2Closure, option3Closure])
    private lazy var textFieldWindow = TextFieldWindow(title: "Text Field Window",
                                                  message: "Text Field Window Message") { [weak self] action, text in
        self?.label.isHidden = false
        self?.currentImageView.isHidden = true
        self?.label.text = text
    }
    private lazy var imageWindow = CustomViewWindow(title: "Custom View Window",
                                          customView: customCollectionView,
                                          message: "Custom View Window Message",
                                          actionText: "Action",
                                          height: 300)
    private let submitWindow = SubmitWindow(title: "Submit Window",
                                            message: "Submit Window Message",
                                            cancelButtonName: "Cancel",
                                            submitButtonName: "Submit") { action in
        
    }
    private lazy var galleryAccessWindow = GalleryAccessWindow(title: "App Would Like to Access Your Photos",
                                                          message: "Users can download images from the app to their devices",
                                                          keepButtonText: "Keep Current Selection",
                                                          selectMoreButtonText: "Select More Photos...",
                                                          targetController: self) { [weak self] identifiers in
  
    }
    
    // MARK: UI Menu
    
    private var menuItems: [UIAction] {
        return [
            UIAction(title: "Alert", image: UIImage(systemName: "exclamationmark.circle.fill"), handler: { [weak self] (_) in
                self?.setCurrentWindow(window: .alert)
            }),
            UIAction(title: "TextField", image: UIImage(systemName: "abc"), handler: { (_) in
                self.setCurrentWindow(window: .textField)
            }),
            UIAction(title: "CustomView", image: UIImage(systemName: "trash"), handler: { [weak self] (_) in
                self?.setCurrentWindow(window: .customView)
            }),
            UIAction(title: "GalleryAccess", image: UIImage(systemName: "trash"), handler: { [weak self] (_) in
                self?.setCurrentWindow(window: .gallery)
            }),
            UIAction(title: "Submit", image: UIImage(systemName: "checkmark.square.fill"), handler: { [weak self] (_) in
                self?.setCurrentWindow(window: .submit)
            }),
            UIAction(title: "Dialog", image: UIImage(systemName: "message.fill"), handler: { [weak self] (_) in
                self?.setCurrentWindow(window: .dialog)
            })
        ]
    }

    private var demoMenu: UIMenu {
        return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        addSubviews()
        setupViewConstraints()
        setupNavigationBar()
    }
    
    // MARK: Helpers
    
    private func setupStyle() {
        view.backgroundColor = UIColor(named: "background")
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Windows", image: nil, primaryAction: nil, menu: demoMenu)
    }
    
    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(currentImageView)
    }
    
    private func setupViewConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            currentImageView.widthAnchor.constraint(equalToConstant: 250),
            currentImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func showGalleryPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: Present windows
    
    private func setCurrentWindow(window: Windows) {
        switch window {
        case .textField:
            currentWindow = textFieldWindow
        case .customView:
            currentWindow = imageWindow
        case .gallery:
            currentWindow = galleryAccessWindow
        case .submit:
            currentWindow = submitWindow
        case .alert:
            currentWindow = alertWindow
        case .dialog:
            currentWindow = dialogWindow
        }
    }
}

// MARK: PHPickerViewControllerDelegate

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.label.isHidden = true
                self?.currentImageView.isHidden = false
                
                if let image = image as? UIImage {
                    self?.currentImageView.image = image
                }
            }
        }
    }
}
