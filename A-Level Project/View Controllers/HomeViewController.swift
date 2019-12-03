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
        
        self.activityIndicator.startAnimating()
        
        let timescale = current.title(for: UIButton.State())
        
        adaptor.getLightweightUser() { lightweightUser in
            self.lightweightUser = lightweightUser
            self.welcomeLabel.text = "Hello, " + (lightweightUser.name ?? "")
            
            self.setChart(readings: lightweightUser.readings, timescale: timescale!)
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
