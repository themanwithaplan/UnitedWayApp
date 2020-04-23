//
//  BKController.swift
//  United Way iOS
//
//  Created by Sharaf Nazaar on 3/5/20.
//  Copyright © 2020 United Way. All rights reserved.
//

import UIKit

class BKControllerOld: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    
    
    
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var userAgeTextField: UITextField!
    @IBOutlet weak var adultAgesTextField: UITextField!
    @IBOutlet weak var childrenAgesTextField: UITextField!
    @IBOutlet weak var utilityBillsSegmentedController: UISegmentedControl!
    @IBOutlet weak var maritalStatusSegmentedController: UISegmentedControl!
    @IBOutlet weak var homelessSegmentedController: UISegmentedControl!
    @IBOutlet weak var taxesSegmentedController: UISegmentedControl!
    @IBOutlet weak var monthlyIncomeTextField: UITextField!
    @IBOutlet weak var monthlyHousingTextField: UITextField!
    @IBOutlet weak var childcareCostTextField: UITextField!
    
    private var outputArray = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let query = queryGenerator();
        print("QUERY: "+query);

        performQuery(query: query)
    }
    
    private func queryGenerator() -> String {
        
        var queryURL = "https://api.benefitkitchen.com/benefits?categories=all&live_zip="
        if let zip = zipTextField.text {
            queryURL += zip
        }
        queryURL += "&monthly_income="
        if let monthlyIncome = monthlyIncomeTextField.text {
            queryURL += monthlyIncome
        }
        
        queryURL += "&persons[0][age]=\(userAgeTextField.text ?? "0")"
        let adultAgesStringArray = adultAgesTextField.text?.split(separator: ",") ?? []
        var personCounter = 1;
        
        for counter in 0..<adultAgesStringArray.count {
            queryURL += "&persons[\(personCounter)][age]=\(adultAgesStringArray[counter])"
            personCounter+=1
        }
        
        let childrenAgesStringArray = childrenAgesTextField.text?.split(separator: ",") ?? []
        
        for counter in 0..<childrenAgesStringArray.count {
            queryURL += "&persons[\(personCounter)][age]=\(childrenAgesStringArray[counter])"
            personCounter+=1
        }
        
        queryURL += "&married=\((maritalStatusSegmentedController.titleForSegment(at: maritalStatusSegmentedController.selectedSegmentIndex)!))"
       
        queryURL += "&homeless=\((homelessSegmentedController.titleForSegment(at: homelessSegmentedController.selectedSegmentIndex)!))"
        
        queryURL += "&utilities_in_name=\((utilityBillsSegmentedController.titleForSegment(at: utilityBillsSegmentedController.selectedSegmentIndex)!))"
        
        queryURL += "&filing_jointly=\((taxesSegmentedController.titleForSegment(at: taxesSegmentedController.selectedSegmentIndex)!))"
        
        queryURL += "&child_care_cost=\(childcareCostTextField.text ?? "0")"
        
        queryURL += "&housing_costs=\(monthlyHousingTextField.text ?? "0")"
        
        queryURL += "&access_token=prod_JtdDbRFnyT2yLomHgn2J"
        
        return queryURL;
    }
    
    private func performQuery(query: String) {
        
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        let request = URLRequest(url: URL(string: query)!)
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let benefits = try JSONDecoder().decode(BenefitModel.self, from: data)
                self.generateOutputArray(benefits: benefits)
                
                DispatchQueue.main.async {
                    self.displayOutput()
                }
                
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(jsonResult)
                }
//                self.ouputArray = []
//                self.createOutputArray(from: expenses)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
               // print(data)
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    private func generateOutputArray(benefits: BenefitModel) {
        
        outputArray.append(["\(benefits.calculators.cctc.cctc_benefit_name)","\(benefits.calculators.cctc.cctc_eligibility)","\(benefits.calculators.cctc.cctc_amount)"])
        
        outputArray.append(["\(benefits.calculators.childcare.childcare_benefit_name)","\(benefits.calculators.childcare.childcare_eligibility)","\(benefits.calculators.childcare.childcare_copay)"])
        
        outputArray.append(["\(benefits.calculators.ctc.ctc_benefit_name)","\(benefits.calculators.ctc.ctc_eligibility)","\(benefits.calculators.ctc.ctc_total)"])
        
        outputArray.append(["\(benefits.calculators.eitc.eitc_benefit_name)","\(benefits.calculators.eitc.eitc_eligibility)","\(benefits.calculators.eitc.eitc_amount)"])
        
        outputArray.append(["\(benefits.calculators.foodstamps.foodstamp_benefit_name)","\(benefits.calculators.foodstamps.foodstamp_eligibility)","\(benefits.calculators.foodstamps.foodstamp_amount)"])
        
        outputArray.append(["\(benefits.calculators.healthcare.adult_health_name)","\(benefits.calculators.healthcare.adult_health_eligibility)","\(benefits.calculators.healthcare.adult_health_copay)"])
        
        outputArray.append(["\(benefits.calculators.healthcare.child_health_name)","\(benefits.calculators.healthcare.child_health_eligibility)","\(benefits.calculators.healthcare.child_health_copay)"])
        
        outputArray.append(["\(benefits.calculators.welfare.welfare_benefit_name)","\(benefits.calculators.welfare.welfare_eligibility)","\(benefits.calculators.welfare.welfare_amount)"])
        
        outputArray.append(["\(benefits.calculators.wic.wic_benefit_name)","\(benefits.calculators.wic.wic_eligibility)","\(benefits.calculators.wic.wic_amount)"])
        
    }
    
    private func displayOutput() {
        
//        print(outputArray)
//        print(outputArray.count)
        for outer in 1..<outputArray.count {
            for inner in 0..<3 {
                var labelText = ""
                if (inner == 0) {
                    labelText += "Benefit:  "
                } else if (inner == 1) {
                    labelText += "Status:   "
                } else {
                    labelText += "Cash:      "
                }
                labelText += outputArray[outer][inner] as? String ?? ""
                let label = UILabel(frame: self.adultAgesTextField.frame)
                label.text = labelText
                label.textColor = UIColor.darkGray
                label.font = UIFont.boldSystemFont(ofSize: 18)
                
                self.mainStackView.addArrangedSubview(label)
                
                if (inner == 2) {
                     let label = UILabel(frame: self.adultAgesTextField.frame)
                     label.text = " "
                     label.font = UIFont.boldSystemFont(ofSize: 18)
                     self.mainStackView.addArrangedSubview(label)
                }
//                print(outputArray[outer][inner])
            }
        }
        
    }

}

//https://api.benefitkitchen.com/benefits?categories=all&live_zip=11215&monthly_income=4000&food%20_stamps=200&child_care_cost=500&persons[0][age]=0&persons[1][age]=8&persons[2][age]=37&access_token=prod_JtdDbRFnyT2yLomHgn2J

