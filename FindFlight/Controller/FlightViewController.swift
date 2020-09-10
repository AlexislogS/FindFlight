//
//  ViewController.swift
//  FindFlight
//
//  Created by Alex Yatsenko on 17.07.2020.
//  Copyright © 2020 Alexislog's Production. All rights reserved.
//

import UIKit

final class FlightViewController: UIViewController {
    
    private var routesData = [String]()
    
    private var numberOfTransfers: Double {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let doubleFromIndex = Double(selectedIndex)
        return doubleFromIndex
    }
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl! {
        didSet {
            setupSegmentedControl()
        }
    }
    @IBOutlet private weak var sourceAirportTextField: UITextField!
    @IBOutlet private weak var destinationAirportTextField: UITextField!
    @IBOutlet private weak var routesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction private func findButtonPressed() {
        findRoute(for: sourceAirportTextField.text ?? "",
                  and: destinationAirportTextField.text ?? "")
    }
    
    private func setupSegmentedControl() {
        let whiteTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let grayTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        UISegmentedControl.appearance().setTitleTextAttributes(whiteTextAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(grayTextAttributes, for: .selected)
    }
    
    private func fetchData() {
        let dataProvider = DataManager()
        dataProvider.readData { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.routesData = data
            case .failure(let error):
                self?.presentAlert(with: "Failed connection to Data Base",
                                   and: "Please try again later")
                print(error.localizedDescription)
            }
        }
    }
    
    private func findRoute(for sourceAirport: String,
                           and destinationAirport: String) {
        var foundRoutesData = [String]()
        var finalRoutes = [String]()
        var countOfTransferRoutes = 0.0
        for routeData in routesData {
            let routes = routeData.components(separatedBy: ",")
            let route = Route(sourceAirport: routes[2],
                              destinationAirport: routes[4])
            if sourceAirport == route.sourceAirport ||
                destinationAirport == route.destinationAirport {
                foundRoutesData.append(routeData)
                let twoPartsOfData = foundRoutesData.split()
                
                let firstPartOfData = twoPartsOfData[0]
                let secondPartOfData = twoPartsOfData[1]
                
                for (first, second) in zip(firstPartOfData, secondPartOfData) {
                    let firstPartRoutes = first.components(separatedBy: ",")
                    let secondPartRoutes = second.components(separatedBy: ",")
                    if firstPartRoutes[2] == secondPartRoutes[4] {
                        countOfTransferRoutes += 0.5
                        if countOfTransferRoutes <= numberOfTransfers {
                            let totalData = secondPartRoutes + firstPartRoutes
                            let finalOutput = totalData.joined(separator: " ")
                            finalRoutes.append(finalOutput)
                            continue
                        }
                    }
                    if sourceAirport == route.sourceAirport &&
                        destinationAirport == route.destinationAirport {
                        finalRoutes.append(routeData)
                    }
                }
            }
        }
        let filteredArrayOfRoutes = finalRoutes.unique
        let textFromFilteredArray = filteredArrayOfRoutes.joined(separator: "\n")
        let formattedTextArray = textFromFilteredArray.components(separatedBy: ",")
        let finalTextOutput = formattedTextArray.joined(separator: " ")
        routesTextView.text = finalTextOutput
    }
    
    private func presentAlert(with tittle: String, and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

