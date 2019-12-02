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
            
            let time = Time()
            
            var dataEntries: [ChartDataEntry] = []
            
            var timeStamps: [String] = []
            
            for i in 0..<scaledReadings!.count {
                let dateTime = scaledReadings![i].timeStamp
                let axisLabel = time.getTimeStamp(withTimescale: timescale, timeStamp: dateTime)
                let glucose = scaledReadings![i].bloodGlucose
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(glucose))
                
                timeStamps.append(axisLabel)
                dataEntries.append(dataEntry)
            }
            
            let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Glucose Level")
            let lineChartData = LineChartData(dataSet: lineChartDataSet)
            
            lineChart.data = lineChartData
            lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeStamps)
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        }
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
