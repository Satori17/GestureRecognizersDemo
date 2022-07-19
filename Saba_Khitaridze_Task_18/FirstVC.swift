//
//  FirstVC.swift
//  Saba_Khitaridze_Task_18
//
//  Created by Saba Khitaridze on 19.07.22.
//

import UIKit


let checkPressName = Notification.Name("com.sabakhitaridze.Saba-Khitaridze-Task-18.tapsDuration")
let changeColorName = Notification.Name("com.sabakhitaridze.Saba-Khitaridze-Task-18.changeColor")

class FirstVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var redView: UIView! {
        didSet {
            redView.layer.cornerRadius = redView.frame.height/2
            redView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var blueView: UIView! {
        didSet {
            blueView.layer.cornerRadius = blueView.frame.height/2
            blueView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var purpleView: UIView! {
        didSet {
            purpleView.makeTriangle()
            purpleView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var blackView: UIView! {
        didSet {
            blackView.makeTriangle()
            blackView.addGestureRecognizer(tapGesture)
        }
    }
    
    //MARK: - Vars & Gesture Recognizers
    private var tapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    }
    
    var isRedView = false
    var isBlueView = false
    
    //timer for long press
    var beginTime: Double = 0
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        //notificationCenter observers
        NotificationCenter.default.addObserver(self, selector: #selector(checkPressDuration), name: checkPressName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeColor), name: changeColorName, object: nil)
    }
    
    //MARK: - Methods
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        isRedView = sender.view == redView
        isBlueView = sender.view == blueView
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondVC") as? SecondVC
        if let secondVC = vc {
            secondVC.isPurpleView = sender.view == purpleView
            secondVC.isBlackView = sender.view == blackView
            navigationController?.pushViewController(secondVC, animated: true)
        }
    }
    
    
    @objc func checkPressDuration(notification: Notification) {
        if let gesture = notification.object as? UILongPressGestureRecognizer {
            switch gesture.state {
            case .began:
                beginTime = Date().timeIntervalSince1970
                
            case .ended, .cancelled, .failed:
                if (Date().timeIntervalSince1970 - beginTime) < 1 {
                    if isRedView {
                        navigationController?.popViewController(animated: true)
                    }
                } else {
                    if isBlueView {
                        UIView.animate(withDuration: 0.5, delay: 0) {
                            gesture.view?.alpha = 0
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
    @objc func changeColor() {
        /*
         თუ სურათი superview-ს გაცდება მაშინ სურათი დაუბრუნდეს საწყისს ზომებს, NotificationCenter-ით შეუცვალოს ბექგრაუნდის ფერი.
         */
        
        //თუ იგულისხმება პირველი გვერდის View:
        view.backgroundColor = UIColor(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), alpha: 1)
        
        //თუ იგულისხმება შავი სამკუთხედის View:        
        //blackView.backgroundColor = UIColor(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), alpha: 1)
    }
}


//MARK: - Extensions

extension UIView {
    func makeTriangle() {
        let viewHeight = self.layer.frame.height
        let viewWidth = self.layer.frame.width
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: viewHeight))
        bezierPath.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        bezierPath.addLine(to: CGPoint(x: viewWidth / 2, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: viewHeight))
        bezierPath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
