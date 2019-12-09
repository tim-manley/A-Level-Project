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
    
    // Configure the nav bar to conform to the ui
    func configureNavBar() {
        
        let navBar = navigationController?.navigationBar
        
        navBar?.barTintColor = #colorLiteral(red: 0.38234514, green: 0.3826470375, blue: 0.9782263637, alpha: 1)
        
        addNavBarImage()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "HamburgerMenu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapMenu)) // When the left button is pressed, the didTapMenu() function is called
    }
    
    // Add the title asset to the nav bar
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
    
    // On menu button press, display the side menu
    @objc func didTapMenu() {
        
        guard let menuController = storyboard?.instantiateViewController(identifier: "menuController") as? SideMenuController else { return }
        
        menuController.didTapMenuType = { menuType in
            // add transition to other views
            self.transitionToNew(menuType)
        }
        menuController.modalPresentationStyle = .overCurrentContext // Overlays the screen
        menuController.transitioningDelegate = self
        present(menuController, animated: true)
    }
    
    // Detects which button has been pressed and then segues to that view
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
    
    // Set up and display the graph
    func setChart(readings: [Reading]?, timescale: String) {
        
        if readings != nil {
            
            let scaledReadings = self.lightweightUser!.getReadingsInTimescale(timescale: timescale)
            var dataEntries: [ChartDataEntry] = []
            
            let timeStampedAverages = averagesOfReadingsWithSameAxisLabel(readings: scaledReadings!, timescale: timescale)
            
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
    
    // Find all the readings with the same axis label, then find the average of those readings.
    func averagesOfReadingsWithSameAxisLabel(readings: [Reading], timescale: String) -> [(String, Double)] {
        
        var timeStampedAverages: [(String, Double)] = [] // Stored as an array of tuples to keep track of each data point's value and axis label
        
        var i = 0
        while i < readings.count { // Ensures no index out of range errors
            let currentReading = readings[i]
            let currentAxisLabel = self.getAxisLabel(withTimescale: timescale, timeStamp: currentReading.timeStamp)
            var tempArray: [Float] = [currentReading.bloodGlucose] // Temporarily stores all the readings with the same axis label
            var j = 1
            var finished = false
            while finished == false && j < readings.count - i { // Loop through all the readings with the same axis label
                let comparisonReading = readings[i+j]
                let comparisonAxisLabel = self.getAxisLabel(withTimescale: timescale, timeStamp: comparisonReading.timeStamp)
                if comparisonAxisLabel == currentAxisLabel { // Check if the axis labels are the same
                    tempArray.append(comparisonReading.bloodGlucose)
                    j += 1 // Move onto next reading
                } else { // If axis labels are different, break from the loop
                    finished = true
                }
            }
            
            // Calculate average of readings with same axis label
            let sumOfTemp = tempArray.reduce(0, +)
            let averageOfTemp = sumOfTemp / Float(tempArray.count)
            
            timeStampedAverages.append((currentAxisLabel, Double(averageOfTemp)))
            
            i += j // Repeat with the first reading with a different timestamp
        }
        
        return timeStampedAverages
    }
    
    // Simplifies the date and time string to look nicer on the graph
    func getAxisLabel(withTimescale: String, timeStamp: String) -> String {
        
        var axisLabel: String
        
        switch withTimescale {
        case "Today": // Isolate the time component of the date time (since all readings are on the same day)
            axisLabel = String(timeStamp.split(separator: " ")[1])
        case "Past Week": // Isolate the date component of the date time
            axisLabel = String(timeStamp.split(separator: " ")[0])
        case "Past Month": // Isolate the date component of the date time
            axisLabel = String(timeStamp.split(separator: " ")[0])
        case "Past Year": // Isolate the month component of the date time
            let date = String(timeStamp.split(separator: " ")[0])
            axisLabel = String(date.split(separator: "-")[0] + "-" + date.split(separator: "-")[1])
        default:
            axisLabel = timeStamp
        }
        
        
        return axisLabel
    }
    
    // Drop down the timescale selection buttons
    @IBAction func dropDownButton(_ sender: UIButton) {
        
        timeScaleButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    // When a timescale button is pressed, rearrange the buttons in order (with selected at top) and redraw the chart
    @IBAction func changeTimeScale(_ sender: UIButton) {
        
        let state = UIButton.State()
        let selectedTitle = sender.title(for: state) // Detects the title of the pressed button
        
        current.setTitle(selectedTitle, for: state)
        
        // Different options based on which button is pressed
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
        
        // Hide the dropdown menu when a button has been pressed
        timeScaleButtons.forEach { (button) in
            button.isHidden = !button.isHidden
        }
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
