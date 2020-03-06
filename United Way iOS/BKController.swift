//
//  BKController.swift
//  United Way iOS
//
//  Created by Sharaf Nazaar on 3/5/20.
//  Copyright © 2020 United Way. All rights reserved.
//

import Foundation
import UIKit

class BKController: UIViewController {
    
//        @IBOutlet weak var dropdownTF: DropDown!
//        @IBOutlet weak var ageLabel: UILabel!
//        @IBOutlet weak var ageTextField: UITextField!
        @IBOutlet weak var tableView: UITableView!
//        @IBOutlet weak var verticalStack: UIStackView!
//        @IBOutlet weak var summaryLabel: UILabel!
        private var selectedCountyCode:String?
        private var ageTextFieldCounter = 1
        private var ouputArray: [(String,Int?,Int?)] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()

        }

    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let countyCode = self.selectedCountyCode {
            
            var urlString: String?
            
            if (self.ageTextFieldCounter == 1) {
                urlString = "https://api.benefitkitchen.com/benefits?categories=all&live_zip="
            } else {
                for age in 1...self.ageTextFieldCounter {
                    if (age == 1) {
                        urlString = "https://api.benefitkitchen.com/benefits?categories=all&live_zip="
                    } else {
                        if let textField = self.view.viewWithTag(age) as? UITextField {
                            if (textField.text != "") {
                                urlString?.append("&persons[\(age-1)][age]=\(textField.text!)")
                            }
                        }
                    }
                }
            }
            let url = URL(string: urlString!)
            //create the session object
            let session = URLSession.shared
            //now create the URLRequest object using the url object
            let request = URLRequest(url: url!)
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let expenses = try JSONDecoder().decode(ExpensesModel.self, from: data)
                    self.ouputArray = []
                    self.createOutputArray(from: expenses)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
            
            
            
        }
    }
    
    private func createOutputArray(from expensesObj: ExpensesModel) {
    self.ouputArray.append(("Housing:",expensesObj.expenses?.rent,expensesObj.expenses?.annualRent))
        self.ouputArray.append(("Child Care:",expensesObj.expenses?.childcare,expensesObj.expenses?.annualChildcare))
        self.ouputArray.append(("Food:",expensesObj.expenses?.food,expensesObj.expenses?.annualFood))
        self.ouputArray.append(("Health care:",expensesObj.expenses?.healthcare,expensesObj.expenses?.annualHealthcare))
        self.ouputArray.append(("Transportation:",expensesObj.expenses?.transportation,expensesObj.expenses?.annualTransportation))
        self.ouputArray.append(("Miscellaneous:",expensesObj.expenses?.misc,expensesObj.expenses?.annualMisc))
        self.ouputArray.append(("Taxes:",expensesObj.monthly_taxes,expensesObj.net_taxes))
    }
    
}

extension BKController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ouputArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.leftLabel.text = self.ouputArray[indexPath.row].0
        if let centerLabelText =  self.ouputArray[indexPath.row].1 {
            cell.centerLabel.text = "\(centerLabelText)"
        }
        if let rightLabelText = self.ouputArray[indexPath.row].2 {
            cell.rightLabel.text = "\(rightLabelText)"
        }
        
        tableView.estimatedRowHeight = 10.0
        tableView.rowHeight = UITableView.automaticDimension
        
        return cell
    
    }

}

extension BKController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
