//
//  HBController.swift
//  United Way Mobile Application
//
//  Created by Sharaf Nazaar on 25/02/20.
//  Copyright © 2019 United Way. All rights reserved.
//

import UIKit

class HBController: UIViewController {

    @IBOutlet weak var dropdownTF: DropDown!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var summaryLabel: UILabel!
    private var selectedCountyCode:String?
    private var ageTextFieldCounter = 1
    private var ouputArray: [(String,Int?,Int?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTextField()
        
        // The list of array to display. Can be changed dynamically
        dropdownTF.optionArray = ["Alameda County",
                                  "Alpine County",
                                  "Amador County",
                                  "Butte County",
                                  "Calaveras County",
                                  "Colusa County",
                                  "Contra Costa County",
                                  "Del Norte County",
                                  "El Dorado County",
                                  "Fresno County",
                                  "Glenn County",
                                  "Humboldt County",
                                  "Imperial County",
                                  "Inyo County",
                                  "Kern County",
                                  "Kings County",
                                  "Lake County",
                                  "Lassen County",
                                  "Los Angeles County",
                                  "Madera County",
                                  "Marin County",
                                  "Mariposa County",
                                  "Mendocino County",
                                  "Merced County",
                                  "Modoc County",
                                  "Mono County",
                                  "Monterey County",
                                  "Napa County",
                                  "Nevada County",
                                  "Orange County",
                                  "Placer County",
                                  "Plumas County",
                                  "Riverside County",
                                  "Sacramento County",
                                  "San Benito County",
                                  "San Bernardino County",
                                  "San Diego County",
                                  "San Francisco County",
                                  "San Joaquin County",
                                  "San Luis Obispo County",
                                  "San Mateo County",
                                  "Santa Barbara County",
                                  "Santa Clara County",
                                  "Santa Cruz County",
                                  "Shasta County",
                                  "Sierra County",
                                  "Siskiyou County",
                                  "Solano County",
                                  "Sonoma County",
                                  "Stanislaus County",
                                  "Sutter County",
                                  "Tehama County",
                                  "Trinity County",
                                  "Tulare County",
                                  "Tuolumne County",
                                  "Ventura County",
                                  "Yolo County",
                                  "Yuba County"]
        //Its Id Values and its optional
        dropdownTF.optionIds = [94501,
95646,
95601,
95965,
95221,
95912,
94506,
95531,
95613,
93210,
95913,
95501,
92222,
92328,
93203,
93202,
95422,
96009,
90001,
93601,
94901,
93623,
95410,
93620,
96006,
93512,
93426,
94503,
95713,
92864,
95602,
95915,
91752,
94203,
95023,
91701,
91901,
94101,
95201,
93401,
94002,
93013,
94022,
95001,
96001,
95910,
95568,
94510,
94922,
95307,
95659,
96021,
95527,
93201,
95305,
91319,
95605,
95692]

        // The the Closure returns Selected Index and String
        dropdownTF.didSelect{(selectedText , index ,id) in
            
            self.selectedCountyCode = String(id);
                print("hello: ",id);
        }
        
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupTextField() {
        self.ageTextField.delegate = self
    }
    
    @IBAction func addPersonButtonPressed(_ sender: UIButton) {
        
        self.ageTextFieldCounter += 1
        
        let label = UILabel(frame: self.ageLabel.frame)
        label.text = "Age:"
        label.textColor = .white
        label.widthAnchor.constraint(equalToConstant: self.ageLabel.frame.size.width).isActive = true
        
        let textField = UITextField(frame: self.ageTextField.frame)
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        
        textField.tag = 2
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        
        horizontalStack.addArrangedSubview(label)
        horizontalStack.addArrangedSubview(textField)
        
        self.verticalStack.addArrangedSubview(horizontalStack)

    }
        
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let countyCode = self.selectedCountyCode {
            
            var urlString: String?
            
            if (self.ageTextFieldCounter == 1) {
                urlString = "https://bing.benefitkitchen.com/api/bing?address=\(countyCode)&persons[0][age]=\(ageTextField.text ?? "0")"
            } else {
                for age in 1...self.ageTextFieldCounter {
                    if (age == 1) {
                        urlString = "https://bing.benefitkitchen.com/api/bing?address=\(countyCode)&persons[\(age-1)][age]=\(ageTextField.text ?? "0")"
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

extension HBController: UITableViewDelegate, UITableViewDataSource {

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

extension HBController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
