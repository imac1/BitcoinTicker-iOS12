//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var currencySymbolsArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currencySymbolSelected = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    // 1. determines how many columns we want in our picker.
    func numberOfComponents(in pickerView : UIPickerView) -> Int {
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return currencyArray[row]
        
    }
//
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      currencySymbolSelected = currencySymbolsArray[row]
        finalURL = baseURL + currencyArray[row]
        getCurrencyData(url: finalURL)
        
    }
   
   
    //MARK: - Networking
    /***************************************************************/
    
    func getCurrencyData(url: String) {
        
        Alamofire.request(finalURL, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Succes, got the currency data!")
                let currencyJSON : JSON = JSON(response.result.value!)
                self.updateCurrencyData(json: currencyJSON)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
        


    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateCurrencyData(json : JSON) {
        
        if let currencyResult = json["ask"].double {
        bitcoinPriceLabel.text = currencySymbolSelected + String (currencyResult)
        }
        else {
            bitcoinPriceLabel.text = "Currency Unavailable"
        }
        
        
    }
    




}

