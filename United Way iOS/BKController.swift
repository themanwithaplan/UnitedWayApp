//
//  BKController.swift
//  United Way iOS
//
//  Created by Sharaf Nazaar on 4/15/20.
//  Copyright © 2020 United Way. All rights reserved.
//

import Foundation
import UIKit

class BKController: UIViewController {

    @IBOutlet weak var eligibilityTableView: UITableView!
    @IBOutlet weak var mStackView: UIStackView!
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

    @IBOutlet weak var scrollView: UIScrollView!
    private var outputArray = [[]]
    private var ageTextFieldCounter = 1
    var constraintBottom : NSLayoutConstraint?

    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

//        if notification.name == UIResponder.keyboardWillHideNotification {
//            yourTextView.contentInset = .zero
//        } else {
//            yourTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//        }
//
//        yourTextView.scrollIndicatorInsets = yourTextView.contentInset
//
//        let selectedRange = yourTextView.selectedRange
//        yourTextView.scrollRangeToVisible(selectedRange)
    }
    
    @IBOutlet weak var taxesQLabel: UILabel!
    @IBAction func marriedSegmentChanged(_ sender: Any) {
        
        switch maritalStatusSegmentedController.selectedSegmentIndex
            
        {
        case 0:
            taxesQLabel.isHidden = false
            taxesQLabel.isEnabled = true
            taxesSegmentedController.isHidden = false
            taxesSegmentedController.isEnabled = true
            
        case 1:
            taxesQLabel.isHidden = true
            taxesQLabel.isEnabled = false
            taxesSegmentedController.isHidden = true
            taxesSegmentedController.isEnabled = false
        default:
            break
        }
        
    }
    private func setupTableView() {
        let nib = UINib(nibName: "BenefitsTVCell", bundle: nil)
        self.eligibilityTableView.register(nib, forCellReuseIdentifier: "BenefitsTVCell")
        self.eligibilityTableView.delegate = self
        self.eligibilityTableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        eligibilityTableView.isHidden = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Do any additional setup after loading the view.
        //scrollView.contentSize = content
        
        scrollView.isScrollEnabled = true;

    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let query = queryGenerator();
        //print("QUERY: "+query);
        performQuery(query: query)
        
        eligibilityTableView.isHidden = false
       
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
        
        let charset = CharacterSet(charactersIn: ",")
        
        let phrase = adultAgesTextField.text ?? "0"

        if let _ = phrase.rangeOfCharacter(from: charset, options: .caseInsensitive) {
           let adultAgesStringArray = adultAgesTextField.text?.split(separator: ",") ?? []
           print ("adultAgesStringArray: ",adultAgesStringArray)
           var personCounter = 0;
           
           for counter in 0..<adultAgesStringArray.count {
               queryURL += "&persons[\(personCounter)][age]=\(adultAgesStringArray[counter])"
               personCounter+=1
           }
        }
        else {
            queryURL += "&persons[0][age]=\(adultAgesTextField.text ?? "0")"
        }
        
        
//        let adultAgesStringArray = adultAgesTextField.text?.split(separator: ",") ?? []
//        print ("adultAgesStringArray: ",adultAgesStringArray)
//        var personCounter = 0;
//
//        for counter in 0..<adultAgesStringArray.count {
//            queryURL += "&persons[\(personCounter)][age]=\(adultAgesStringArray[counter])"
//            personCounter+=1
//        }
        
        
        
//        if (self.ageTextFieldCounter == 1) {
//            queryURL += "&persons[0][age]=\(adultAgesTextField.text ?? "0")"
//        } else {
//            for age in 1...self.ageTextFieldCounter {
//                if (age == 1) {
//                    urlString = "https://bing.benefitkitchen.com/api/bing?address=\(countyCode)&persons[\(age-1)][age]=\(ageTextField.text ?? "0")"
//                } else {
//                    if let textField = self.view.viewWithTag(age) as? UITextField {
//                        if (textField.text != "") {
//                            urlString?.append("&persons[\(age-1)][age]=\(textField.text!)")
//                        }
//                    }
//                }
//            }
//        }
//
//
//
//        queryURL += "&persons[0][age]=\(userAgeTextField.text ?? "0")"
//        let adultAgesStringArray = adultAgesTextField.text?.split(separator: ",") ?? []
//        var personCounter = 1;
//
//        for counter in 0..<adultAgesStringArray.count {
//            queryURL += "&persons[\(personCounter)][age]=\(adultAgesStringArray[counter])"
//            personCounter+=1
//        }
//
//        let childrenAgesStringArray = childrenAgesTextField.text?.split(separator: ",") ?? []
//
//        for counter in 0..<childrenAgesStringArray.count {
//            queryURL += "&persons[\(personCounter)][age]=\(childrenAgesStringArray[counter])"
//            personCounter+=1
//        }
        
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
                self.outputArray = []
                self.generateOutputArray(benefits: benefits)
                
//                DispatchQueue.main.async {
//                    self.displayOutput()
//                }
                
//                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                   //print(jsonResult)
//                }
                
//                self.createOutputArray(from: expenses)
                DispatchQueue.main.async {
                    self.eligibilityTableView.reloadData()
                }
               // print(data)
            } catch let error {
                self.showSimpleAlert(message: error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    func showSimpleAlert(message: String) {
//        var message = "";
//        if (option == 0){
//            message = "Please select your county"
//        }
//        else {
//            message = "Please add the age of household members"
//        }
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "Error", message: message,         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
            }
    }
    
    private func generateOutputArray(benefits: BenefitModel) {
        
        if (benefits.calculators.wic.wic_eligibility == "Eligible"){
            outputArray.append(["\(benefits.calculators.wic.wic_benefit_name)","\(benefits.calculators.wic.wic_eligibility)","\(benefits.calculators.wic.wic_amount)"])
        }

        if (benefits.calculators.cctc.cctc_eligibility == "Eligible"){
            outputArray.append(["\(benefits.calculators.cctc.cctc_benefit_name)","\(benefits.calculators.cctc.cctc_eligibility)","\(benefits.calculators.cctc.cctc_amount)"])
        }
        
        if (benefits.calculators.childcare.childcare_eligibility == "Eligible"){
            outputArray.append(["\(benefits.calculators.childcare.childcare_benefit_name)","\(benefits.calculators.childcare.childcare_eligibility)","\(benefits.calculators.childcare.childcare_copay)"])
        }
        
        if (benefits.calculators.ctc.ctc_eligibility == "Eligible"){
           outputArray.append(["\(benefits.calculators.ctc.ctc_benefit_name)","\(benefits.calculators.ctc.ctc_eligibility)","\(benefits.calculators.ctc.ctc_total)"])
        }
        
        if (benefits.calculators.eitc.eitc_eligibility == "Eligible"){
            outputArray.append(["\(benefits.calculators.eitc.eitc_benefit_name)","\(benefits.calculators.eitc.eitc_eligibility)","\(benefits.calculators.eitc.eitc_amount)"])
        }
        
        if (benefits.calculators.foodstamps.foodstamp_eligibility == "Eligible"){
            outputArray.append(["\(benefits.calculators.foodstamps.foodstamp_benefit_name)","\(benefits.calculators.foodstamps.foodstamp_eligibility)","\(benefits.calculators.foodstamps.foodstamp_amount)"])
        }
        
//        if (benefits.calculators.healthcare.adult_health_eligibility == "Eligible"){
//            outputArray.append(["\(benefits.calculators.healthcare.adult_health_name)","\(benefits.calculators.healthcare.adult_health_eligibility)","\(benefits.calculators.healthcare.adult_health_copay)"])
//        }
        
        if (benefits.calculators.healthcare.child_health_eligibility == "Eligible"){
            outputArray.append(["\(benefits.calculators.healthcare.child_health_name)","\(benefits.calculators.healthcare.child_health_eligibility)","\(benefits.calculators.healthcare.adult_health_copay)"])
        }
        
//        if (benefits.calculators.welfare.welfare_eligibility == "Eligible"){
//            outputArray.append(["\(benefits.calculators.welfare.welfare_benefit_name)","\(benefits.calculators.welfare.welfare_eligibility)","\(benefits.calculators.welfare.welfare_amount)"])
//        }
        
    }
    
    private func displayOutput() {
        print(outputArray)
        print("outputArray.count: ", outputArray.count)
        for outer in 1..<outputArray.count {
            for inner in 0..<3 {
                var labelText = ""
                let label = UILabel(frame: self.adultAgesTextField.frame)
                label.textColor = UIColor.darkGray
                label.font = UIFont.boldSystemFont(ofSize: 14)
                
                if (inner == 0) {
                    labelText += "Benefit:  "
                    labelText += outputArray[outer][inner] as? String ?? ""
                    label.text = labelText
                    
                } else if (inner == 1) {
                    labelText += "Status:  Likely Eligible"
                } else {
                    labelText += "Cash:      "
                    labelText += outputArray[outer][inner] as? String ?? ""
                    label.text = labelText
                }
                
                
                
                self.mStackView.addArrangedSubview(label)
                
//                if (inner == 2) {
//                     let label = UILabel(frame: self.adultAgesTextField.frame)
//                     label.text = " "
//                     label.font = UIFont.boldSystemFont(ofSize: 14)
//                     self.mStackView.addArrangedSubview(label)
//                }
                
                //print(outputArray[outer][inner])
            }
        }
        
       // constraintBottom = self.mStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200)
//        constraintBottom?.isActive = true
//
        self.mStackView.setNeedsLayout()
        self.mStackView.layoutIfNeeded()

      //  self.scrollView.addSubview(mStackView)
    }
    
    

}

extension BKController: UITableViewDelegate, UITableViewDataSource {
    
 func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print ("outputArray.count: ", outputArray.count)
        
        if (outputArray.count > 0){
            if(outputArray[0].count > 0){
                return outputArray.count
            }
            else {
                return 0
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedBenefit = outputArray[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "BenefitDetailView") as! BenefitDetailController
        detailVC.benefitName = selectedBenefit[0] as! String
        self.present(detailVC, animated: true, completion: nil)

        
        
//      let benefitDet = outputArray[indexPath.row] as String
//      let benefitDetModel = benefitDet.data(using: .utf8)!
//        do {
//            let selectedBenefit = try JSONDecoder().decode(BenefitDetailModel.self, from: benefitDetModel)
//        } catch let error {
//            
//        }
        
      //  performSegue(withIdentifier: "benefitDetailSegue", sender: self)
        
//        if let viewController = storyboard?.instantiateViewController(identifier: "BenefitDetailView") as? BenefitDetailController {
//            viewController.benefitName = selectedBenefit[0] as! String
//            navigationController?.pushViewController(viewController, animated: true)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if  segue.identifier == "benefitDetailSegue",
//        let destination = segue.destination as? BenefitDetailController,
//        let currentIndex = eligibilityTableView.indexPathForSelectedRow?.row
//
////        if  (segue.identifier == "benefitDetailSegue",
////            let destination = segue.destination as? BenefitDetailController,
////            let currentIndex = eligibilityTableView.indexPathForSelectedRow?.row
////            let blogIndex = tableView.indexPathForSelectedRow?.row
//        {
//            let selectedBenefit = outputArray[currentIndex]
//            destination.benefitName = selectedBenefit[0] as? String
//        }
        
        if (segue.identifier == "benefitDetailSegue"){
            
            let viewController = segue.destination as! BenefitDetailController
            let currentIndex = eligibilityTableView.indexPathForSelectedRow?.row ?? 0
            let selectedBenefit = outputArray[currentIndex]
                       viewController.benefitName = selectedBenefit[0] as? String
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitsTVCell", for: indexPath) as! BenefitsTVCell
        
//        print ("outputArray.value: ", outputArray[indexPath.row])
        
        var labelText = ""
        var labelText2 = ""
        var labelText3 = ""
        
        labelText = "Benefit:  "
        labelText += outputArray[indexPath.row][0] as! String;
        
        labelText2 = "Status:   "
        labelText2 += outputArray[indexPath.row][1] as! String;
        
        labelText3 = "Cash:     $"
        labelText3 += outputArray[indexPath.row][2] as! String;
        
        cell.topLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.centerLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.bottomLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell.topLabel?.text = labelText
        cell.centerLabel?.text = labelText2
        cell.bottomLabel?.text = labelText3

        cell.topLabel?.textColor = UIColor.darkGray
        cell.centerLabel?.textColor = UIColor.darkGray
        cell.bottomLabel?.textColor = UIColor.darkGray

        return cell
    }


//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitsTVCell", for: indexPath) as! BenefitsTVCell
//
//        print ("indexPath.row: ", indexPath.row)
//        print ("outputArray.count: ", outputArray.count)
//
//
//        for outer in 1...outputArray.count {
//           // for inner in 0..<3 {
//                var labelText = ""
//                var labelText2 = ""
//                var labelText3 = ""
//
//               // if (inner == 0) {
//                    labelText += "Benefit:  "
//                   // print ("outputArray[outer][0]: ",outputArray[indexPath.row][0])
//                    labelText += outputArray[outer][0] as? String ?? ""
//
//                    cell.topLabel = UILabel(frame: self.adultAgesTextField.frame)
//                    cell.topLabel?.text = labelText as? String ?? ""
////                    cell.topLabel.textColor = UIColor.darkGray
////                    cell.topLabel.font = UIFont.boldSystemFont(ofSize: 15)
//
//               // } else if (inner == 1) {
//                print ("outputArray[outer][1]: ",outputArray[outer][1])
//
//                    labelText2 += "Status:   "
//                    labelText2 += outputArray[outer][1] as? String ?? ""
//                    cell.centerLabel?.text = labelText2
//
//
//             //   } else {
//                print ("outputArray[outer][2]: ",outputArray[outer][2])
//
//                    labelText3 += "Cash:      "
//                    labelText3 += outputArray[outer][2] as? String ?? ""
//                    cell.bottomLabel?.text = labelText3
//            //    }
//                //let label = UILabel(frame: self.adultAgesTextField.frame)
////                cell.leftLabel.text = labelText
////                cell.leftLabel.textColor = UIColor.darkGray
////                cell.leftLabel.font = UIFont.boldSystemFont(ofSize: 15)
////
//
//                cell.topLabel?.textColor = UIColor.darkGray
//                cell.centerLabel?.textColor = UIColor.darkGray
//                cell.bottomLabel?.textColor = UIColor.darkGray
////                cell.topLabel.font = UIFont.boldSystemFont(ofSize: 15)
////                cell.centerLabel.font = UIFont.boldSystemFont(ofSize: 15)
////                cell.bottomLabel.font = UIFont.boldSystemFont(ofSize: 15)
////
//
////                if (inner == 2) {
////                     let label = UILabel(frame: self.adultAgesTextField.frame)
////                     label.text = " "
////                     label.font = UIFont.boldSystemFont(ofSize: 15)
////                   //  self.mStackView.addArrangedSubview(label)
////                }
//
//                //print(outputArray[outer][inner])
//         //   }
//        }
//
////            cell.leftLabel.text = self.outputArray[indexPath.row][0] as? String
////        if let centerLabelText =  self.outputArray[indexPath.row][1] as? Any{
////                cell.centerLabel.text = "\(centerLabelText)"
////            }
////        if let rightLabelText = self.outputArray[indexPath.row][2] as? Any{
////                cell.rightLabel.text = "\(rightLabelText)"
////            }
//
//            tableView.estimatedRowHeight = 150.0
//            tableView.rowHeight = UITableView.automaticDimension
//
//
//            return cell
//
//    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection
//                                section: Int) -> String? {
//       return "                               Monthly               Annually"
//    }

}


//https://api.benefitkitchen.com/benefits?categories=all&live_zip=11215&monthly_income=4000&food%20_stamps=200&child_care_cost=500&persons[0][age]=0&persons[1][age]=8&persons[2][age]=37&access_token=prod_JtdDbRFnyT2yLomHgn2J


