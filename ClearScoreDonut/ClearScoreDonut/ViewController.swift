//
//  ViewController.swift
//  ClearScoreDonut
//
//  Created by Chris on 13/03/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel! //not a big fan of the name here, but it is descriptive enough for this. it literally just holds some text.
    @IBOutlet weak var scoreLabel: UILabel!
    fileprivate let request = Request()
    @IBOutlet weak var maximumScoreLabel: UILabel!
    var customer: Customer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCircle(radius: 180, colour: UIColor.black.cgColor,lineWidth: 4, isShowingScore: false)
        self.textLabel.text = "Your Credit Score is Loading..\n Please Wait"
        self.getCustomerData()
        
    }
    
    
    func getCustomerData() {
        
        request.getCustomerDataFromURL() { customerData, error in
            if error == nil && customerData != nil {
                guard let customer = customerData else {print("failed to get CustomerData"); return }
                DispatchQueue.main.async {
                    self.setCustomer(customer: customer)
                }
            }else{
                guard let error = error else { assertionFailure("Should not have reached here"); return }
                self.displayErrorAlert(error: error)
            }
        }
        
    }
    
    func setCustomer(customer: Customer) {
        self.customer = customer
        addCircle(radius: 180, colour: UIColor.black.cgColor,lineWidth: 4, isShowingScore: false)
        addCircle(radius: 170, colour: UIColor.black.cgColor,lineWidth: 5, isShowingScore: true)
    }
    
    //this is a general method to add a circle to the middle of the view. this can be extended to support drawing a circle from any given point on the screen
    func addCircle(radius: CGFloat, colour: CGColor, lineWidth: Int, isShowingScore: Bool) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.view.bounds // need this for the rotation transform to work correctly
        self.view.layer.addSublayer(shapeLayer)
        
        let startAngle =  CGFloat(-M_PI_2) //always start at 12 o'clock
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = CGFloat(lineWidth)
        shapeLayer.strokeEnd = 0.0
        
        //draw the arc conditionally, for showing a score - with gradient and animation, or just a circle, for whatever reason you might need a circle.
        if isShowingScore {
            
            let score = self.scoreToDegrees(score: (self.customer?.creditScore)!, maxScore: (self.customer?.maxCreditScore)!)
            let endAngle = self.degrees2Radians(degrees: score)
            
            shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.view.center.x, y: self.view.center.y), radius: CGFloat(radius), startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = shapeLayer.bounds
            gradientLayer.colors = [UIColor.orange.cgColor ,UIColor.yellow.cgColor]
            gradientLayer.mask = shapeLayer
            self.view.layer.addSublayer(gradientLayer)
            self.animateCircle(duration: 2.0, layer: shapeLayer)
            self.configureLabels()
            
        } else {
            
            let endAngle = degrees2Radians(degrees: 360)
            shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.view.center.x, y: self.view.center.y), radius: CGFloat(radius), startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
            shapeLayer.strokeColor = colour
            shapeLayer.strokeEnd = 1.0
        }
        
        
    }
    
    func animateCircle(duration: TimeInterval, layer: CAShapeLayer){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        layer.strokeEnd = 1.0
        layer.add(animation, forKey: "animateCircle")
    }
    
    func degrees2Radians(degrees: Double) -> CGFloat{
        
        return CGFloat( degrees * M_PI / 180)
    }
    
    func scoreToDegrees(score: Double, maxScore: Double) -> Double {
        //this takes the maxScore and score and returns the value in degrees, for easier calculation.
        return (score / maxScore) * 180
    }
    
    func configureLabels(){
        
        let score = Int(self.customer.creditScore)
        let maxScore = Int(self.customer.maxCreditScore)
        self.scoreLabel.textColor = UIColor.orange
        self.scoreLabel.text = "\(score)"
        self.maximumScoreLabel.text = "out of: \(maxScore)"
        self.textLabel.text = "Your Credit Score is:"
    }
    
    func displayErrorAlert(error: Error){
        let alert = UIAlertController(title: "UPS! Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { action in self.getCustomerData()}
        alert.addAction(retryAction)
        self.show(alert, sender: self)
    }
}

