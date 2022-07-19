//
//  SecondVC.swift
//  Saba_Khitaridze_Task_18
//
//  Created by Saba Khitaridze on 19.07.22.
//

import UIKit

class SecondVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            //long press gesture
            posterImageView.addGestureRecognizer(longPressGesture)
            //swipe gesture
            directions.forEach { swipeDirection in
                let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(imageSwiped))
                swipeGesture.direction = swipeDirection
                posterImageView.addGestureRecognizer(swipeGesture)
            }
            //pinch gesture
            posterImageView.addGestureRecognizer(pinchGesture)
        }
    }
    
    //MARK: - Gesture Recognizers
    private var longPressGesture: UILongPressGestureRecognizer {
        return UILongPressGestureRecognizer(target: self, action: #selector(imagePressed))
    }
    
    private var pinchGesture: UIPinchGestureRecognizer {
        return UIPinchGestureRecognizer(target: self, action: #selector(imagePinched))
    }
    
    let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right, .up, .down]
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Vars
    
    var isPurpleView = false
    var isBlackView = false

    //MARK: - Methods
    
    @objc func imagePressed(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: checkPressName, object: sender)
    }
    
    @objc func imageSwiped(_ sender: UISwipeGestureRecognizer) {
        if isPurpleView {
        guard let image = sender.view else { return }
        if sender.direction == .up || sender.direction == .right {
            UIView.animate(withDuration: 0.3, delay: 0) {
                image.center = CGPoint(x: image.center.x + 50, y: image.center.y)
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0) {
                image.center = CGPoint(x: image.center.x - 50, y: image.center.y)
            }
        }
        }
    }
    
    @objc func imagePinched(_ sender: UIPinchGestureRecognizer) {
        if isBlackView {
            if let image = sender.view as? UIImageView {
                image.transform = image.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
                
                if let superView = self.view.superview {
                    if image.frame.size.width > superView.frame.size.width && image.frame.size.height > superView.frame.size.height {
                        UIView.animate(withDuration: 0.5, delay: 0) {
                            image.transform = CGAffineTransform.identity
                            NotificationCenter.default.post(name: changeColorName, object: nil)
                        }
                    }
                }
            }
        }
    }
    
}
