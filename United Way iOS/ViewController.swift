//
//  ViewController.swift
//  United Way Mobile Application
//
//  Created by ARNAV SINGHANIA on 11/10/19.
//  Copyright © 2019 ARNAV SINGHANIA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countyPickerView: UIPickerView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var summaryLabel: UILabel!
    private var selectedCountyCode:String?
    private var ageTextFieldCounter = 1
    
    private let countyPickerDataSource = [("Alameda County","94501"),("Alpine County","95646"),("Amador County","95601"),("Butte County","95965"),("Calaveras County","95221"),("Colusa County","95912"),("Contra Costa County","94506"),("Del Norte County","95531"),("El Dorado County","95613"),("Fresno County","93210"),("Glenn County","95913"),("Humboldt County","95501"),("Imperial County","92222"),("Inyo County","92328"),("Kern County","93203"),("Kings County","93202"),("Lake County","95422"),("Lassen County","96009"),("Los Angeles County","90001"),("Madera County","93601"),("Marin County","94901"),("Mariposa County","93623"),("Mendocino County","95410"),("Merced County","93620"),("Modoc County","96006"),("Mono County","93512"),("Monterey County","93426"),("Napa County","94503"),("Nevada County","95713"),("Orange County","92864"),("Placer County","95602"),("Plumas County","95915"),("Riverside County","91752"),("Sacramento County","94203"),("San Benito County","95023"),("San Bernardino County","91701"),("San Diego County","91901"),("San Francisco County","94101"),("San Joaquin County","95201"),("San Luis Obispo County","93401"),("San Mateo County","94002"),("Santa Barbara County","93013"),("Santa Clara County","94022"),("Santa Cruz County","95001"),("Shasta County","96001"),("Sierra County","95910"),("Siskiyou County","95568"),("Solano County","94510"),("Sonoma County","94922"),("Stanislaus County","95307"),("Sutter County","95659"),("Tehama County","96021"),("Trinity County","95527"),("Tulare County","93201"),("Tuolumne County","95305"),("Ventura County","91319"),("Yolo County","95605"),("Yuba County","95692")]
    private let array = ["first","second","third"]
    private var ouputArray: [(String,Int?,Int?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountyPickerView()
        setupTableView()
        setupTextField()
    }

    private func setupCountyPickerView() {
        self.countyPickerView.dataSource = self
        self.countyPickerView.delegate = self
        self.countyPickerView.selectRow(3, inComponent: 0, animated: true)
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
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

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countyPickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountyCode = self.countyPickerDataSource[row].1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countyPickerDataSource[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.countyPickerDataSource[row].0, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}
    

extension ViewController: UITableViewDelegate, UITableViewDataSource {

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
        return cell
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
