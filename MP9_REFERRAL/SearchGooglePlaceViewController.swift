//
//  SearchGooglePlaceViewController.swift
//  MP9_REFERRAL
//
//  Created by macrew on 03/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire

class SearchGooglePlaceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

     var resultsArray = [GooglePlaceInfo]()
     var placesClient: GMSPlacesClient!
    
    var countryName:String?
    var stateName:String?
    var cityName:String?
    ////////////
    var BlogCountryList: StateCity.CountryListing?
    var BlogStatesList: StateCity.StatesListing?
    var BlogCitiesList: StateCity.CitiesListing?
    var countryIdSelected : String?
    var countryCodeSelected : String?
    var stateIdSelected : String?
    var cityIdSelected : String?
    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var SearchBarMain: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMain.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.SearchBarMain.delegate = self
        self.SearchBarMain.becomeFirstResponder()
        self.tableViewMain.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:Error?) -> Void in
            print("Results==\(results)")
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    var dict = GooglePlaceInfo()
                    dict.placeName = result.attributedFullText.string
                    dict.placeId = result.placeID
                    self.resultsArray.append(dict) //append(result.attributedFullText.string)
                    print("ResultsARRAY1==\(String(describing: self.resultsArray))")
                }
            }
            print("ResultsARRAY==\(String(describing: self.resultsArray))")
            if((self.resultsArray.count) > 0)
            {
                self.tableViewMain.isHidden = false
                self.tableViewMain.delegate = self
                self.tableViewMain.dataSource = self
                self.tableViewMain.reloadData()
            }
            else{
                self.tableViewMain.isHidden = true
                self.showAlert(withMessage: "No Data Found!")
                return
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.resultsArray.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.resultsArray[indexPath.row]
        cell.textLabel?.text = dic.placeName
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.resultsArray[indexPath.row]
        let placeID = dic.placeId
       // self.funcGetPlaceDetail(placeId : placeID)
        print("dic==\(dic)")
        print("placeID==\(String(describing: placeID))")
        placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID((placeID)!, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(String(describing: placeID))")
                return
            }
            print("PLACEEEEEEE=\(place)")
            print("Place addRComponents \(String(describing: place.addressComponents))")
            
            for result in place.addressComponents!{
                if let result = result as? GMSAddressComponent
                {
                    
                    let type = result.type
                   
                    print("type==\(type)")
                    if( type == "country")
                    {
                        self.countryName = result.name
                    }
                    if( type == "administrative_area_level_1")
                    {
                        self.stateName = result.name
                    }
                    if( type == "administrative_area_level_2")
                    {
                        self.cityName = result.name
                    }
                }
            }
            
            self.funcGetAllCountryListing(country:self.countryName! , place: place)
            
          
           
            
           
        })
       
    }
    
   
    
    func funcGetAllCountryListing(country: String, place:GMSPlace)
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        _=NetworkHelper().makeRequest(withAPIProvider: .getCountryListing(), completion: { (error, responseBodyModel) in
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard responseBodyModel.bodyData != nil
                    else
                {
                    self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noData)
                    
                    return
                }
                if statusCode == 200
                {
                    guard let blog = try? JSONDecoder().decode((StateCity.CountryListing).self, from: responseBodyModel.bodyData!)
                        else
                    {
                        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                        return
                    }
                    for dict in blog.countries
                    {
                        if dict.name.lowercased() == country.lowercased()
                        {
                            self.countryIdSelected = String(dict.id )
                            self.funcGetAllStates(countryID:self.countryIdSelected!, place: place)
                            break
                        }
                    }
                    self.BlogCountryList = blog
                   
                }
                else
                {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
            
        })
        

    }
    func funcGetAllStates(countryID: String, place:GMSPlace)
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        _=NetworkHelper().makeRequest(withAPIProvider: .GetAllStatesByCountryId(id: countryID), completion: { (error, responseBodyModel) in
            if let responseBodyModel = responseBodyModel {
                let statusCode = responseBodyModel.statusCode
                guard responseBodyModel.bodyData != nil
                    else
                {
                    self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noData)
                    return
                }
                if statusCode == 200
                {
                    guard let blog = try? JSONDecoder().decode((StateCity.StatesListing).self, from: responseBodyModel.bodyData!)
                        else
                    {
                        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
                        return
                    }
                    for dict in blog.states
                    {
                        if dict.name.lowercased() == self.stateName?.lowercased() || dict.name.lowercased() == self.cityName?.lowercased()
                        {
                            self.stateIdSelected = String(dict.id )
                            self.cityIdSelected = String(dict.id)
                            self.funcGetAllCities(stateID:self.stateIdSelected!, place: place)
                            break
                        }
                    }
                    
                }
                else
                {
                    self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
    func funcGetAllCities(stateID: String, place: GMSPlace)
    {
        if Connectivity.isConnectedToInternet == false
        {
            self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noNetwork)
            return
        }
        _=NetworkHelper().makeRequest(withAPIProvider: .GetAllCitiesByStateId(id: stateID), completion: { (error, responseBodyModel) in
        if let responseBodyModel = responseBodyModel {
        let statusCode = responseBodyModel.statusCode
        guard responseBodyModel.bodyData != nil
        else
        {
        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.noData)
        return
        }
        if statusCode == 200
        {
        guard let blog = try? JSONDecoder().decode((StateCity.CitiesListing).self, from: responseBodyModel.bodyData!)
        else
        {
        self.showAlert(withMessage: GlobalConstants.ApiErrorMessage.unableToDecode)
        return
        }
            for dict in blog.cities
            {
                if dict.name.lowercased() == self.stateName?.lowercased() || dict.name.lowercased() == self.cityName?.lowercased()
                {
                    self.cityIdSelected = String(dict.id )
                    break
                    
                }
            }
            
            self.funcUpdatePlaceINfo(place: place)
       
        }
        else
        {
        self.showAlert(withMessage: error?.localizedDescription ?? responseBodyModel.responseMessage ?? ErrorType.unknown.localizedDescription)
        }
        
        } else {
        
        }
        })
    }
    
    func funcUpdatePlaceINfo(place: GMSPlace)
    {
        let dictOfPlace = placeFullInfo.init(name: place.name, email: "", address: place.formattedAddress, countryID: self.countryIdSelected, cityID: self.cityIdSelected, stateID: self.stateIdSelected, phoneNo: place.phoneNumber, postalCode: "", placeId: place.placeID, lat: String(place.coordinate.latitude), lng: String(place.coordinate.longitude))
        
        print("place====\(dictOfPlace)")
        
        GlobalConstants.GooglePLACEAPi.placeFullInfo = dictOfPlace
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
