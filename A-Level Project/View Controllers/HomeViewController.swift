//
//  HomeViewController.swift
//  A-Level Project
//
//  Created by Manley, Timothy (NCWS) on 07/05/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import UIKit
import Firebase
import Charts

class HomeViewController: UIViewController {
    
    let transition = SlideTransition()
    
    let adaptor = FirebaseAdaptor()
    var lightweightUser: LightweightUser? = nil
    var uid: String? = nil
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet var timeScaleButtons: [UIButton]!
    
    @IBOutlet weak var current: UIButton!
    @IBOutlet weak var top: UIButton!
    @IBOutlet weak var middle: UIButton!
    @IBOutlet weak var bottom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.activityIndicator.startAnimating()
        
        configureNavBar()
        
        let timescale = current.title(for: UIButton.State())
        
        adaptor.getLightweightUser() { lightweightUser in
            self.lightweightUser = lightweightUser
            self.welcomeLabel.text = "Hello, " + (lightweightUser.name ?? "")
            
            self.setChart(readings: lightweightUser.readings, timescale: timescale!)
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculatorSegue" {
            let controller = segue.destination as! CalculatorViewController
            controller.uid = self.uid
        } else if segue.identifier == "profileSegue" {
            let controller = segue.destination as! ProfileViewController
            controller.uid = self.uid
        }
    }
    
    
    func configureNavBar() {
        
        let navBar = navigationController?.navigationBar
        
        navBar?.barTintColor = #colorLiteral(red: 0.38234514, green: 0.3826470375, blue: 0.9782263637, alpha: 1)
        
        addNavBarImage()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "HamburgerMenu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapMenu))
    }
    
    func addNavBarImage() {
        
        let navBar = navigationController!.navigationBar
        
        let image = #imageLiteral(resourceName: "Home")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navBar.frame.size.width
        let bannerHeight = navBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image.size.width
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .center
        
        navigationItem.titleView = imageView
    }
    
    @objc func didTapMenu() {
        
        guard let menuController = storyboard?.instantiateViewController(identifier: "menuController") as? SideMenuController else { return }
        menuController.didTapMenuType = { menuType in
            // add transition to other views
            self.transitionToNew(menuType)
        }
        menuController.modalPresentationStyle = .overCurrentContext
        menuController.transitioningDelegate = self
        present(menuController, animated: true)
    }
    
    func transitionToNew(_ menuType: MenuType) {
        switch menuType {
        case .home:
            break
        case .profile:
            self.performSegue(withIdentifier: "profileSegue", sender: self)
        case .logout:
            // Return to login
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setChart(readings: [Reading]?, timescale: String) {
        
        if readings != nil {
            
            let scaledReadings = self.lightweightUser!.getReadingsInTimescale(timescale: timescale)
            var dataEntries: [ChartDataEntry] = []
            
            let timeStampedAverages = averagesOfReadingsWithSameAxisLabel(scaledReadings: scaledReadings!, timescale: timescale)
            
            var axisLabels: [String] = []
            
            for i in 0..<timeStampedAverages.count {
                let (axisLabel, value) = timeStampedAverages[i]
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(value))
                dataEntries.append(dataEntry)
                axisLabels.append(axisLabel)
            }
            
            let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Glucose Level")
            let lineChartData = LineChartData(dataSet: lineChartDataSet)
            
            lineChart.data = lineChartData
            lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: axisLabels)
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        }
    }
    
    // Find all the readings with the same axis label, then find the average of those readings and add it to dataEntries
    func averagesOfReadingsWithSameAxisLabel(scaledReadings: [Reading], timescale: String) -> [(String, Double)] {
        
        var timeStampedAverages: [(String, Double)] = [] // Stored as an array of tuples to keep track of each data point's value and axis label
        
        let time = Time()
        
        var i = 0
        while i < scaledReadings.count {
            let currentReading = scaledReadings[i]
            let currentTimeStamp = currentReading.timeStamp
            let currentAxisLabel = time.getAxisLabel(withTimescale: timescale, timeStamp: currentTimeStamp)
            var tempArray: [Float] = []
            var j = 1
            var finished = false
            while finished == false && j < scaledReadings.count - i {
                let comparisonReading = scaledReadings[i+j]
                let comparisonTimeStamp = comparisonReading.timeStamp
                let comparisonAxisLabel = time.getAxisLabel(withTimescale: timescale, timeStamp: comparisonTimeStamp)
                if comparisonAxisLabel == currentAxisLabel {
                    tempArray.append(comparisonReading.bloodGlucose)
                    j += 1
                } else {
                    finished = true
                }
            }
            tempArray.append(currentReading.bloodGlucose)
            let sumOfTemp = tempArray.reduce(0, +)
            let averageOfTemp = sumOfTemp / Float(tempArray.count)
            timeStampedAverages.append((currentAxisLabel, Double(averageOfTemp)))
            
            i += j
        }
        
        return timeStampedAverages
    }
    
    @IBAction func dropDownButton(_ sender: UIButton) {
        
        timeScaleButtons.forEach { (button) in
            button.isHidden = !button.isHidden
        }
        
    }
    
    @IBAction func changeTimeScale(_ sender: UIButton) {
        
        let state = UIButton.State()
        let selectedTitle = sender.title(for: state)
        
        current.setTitle(selectedTitle, for: state)
        
        switch selectedTitle {
            
        case "Today":
            top.setTitle("Past Week", for: state)
            middle.setTitle("Past Month", for: state)
            bottom.setTitle("Past Year", for: state)
            
            self.setChart(readings: self.lightweightUser!.readings, timescale: "Today")
            
        case "Past Week":
            top.setTitle("Today", for: state)
            middle.setTitle("Past Month", for: state)
            bottom.setTitle("Past Year", for: state)
            
            self.setChart(readings: self.lightweightUser!.readings, timescale: "Past Week")
        
        case "Past Month":
            top.setTitle("Today", for: state)
            middle.setTitle("Past Week", for: state)
            bottom.setTitle("Past Year", for: state)
            
            self.setChart(readings: self.lightweightUser!.readings, timescale: "Past Month")
            
        case "Past Year":
            top.setTitle("Today", for: state)
            middle.setTitle("Past Week", for: state)
            bottom.setTitle("Past Month", for: state)
            
            self.setChart(readings: self.lightweightUser!.readings, timescale: "Past Year")
        
        default:
            break
        }
        
        timeScaleButtons.forEach { (button) in
            button.isHidden = !button.isHidden
        }
        
        self.viewDidLoad()
        
    }

}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
