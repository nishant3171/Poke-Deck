//
//  Pokedex.swift
//  PokemonDeck
//
//  Created by nishant punia on 22/01/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import Foundation
import Alamofire

class Pokedex {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonUrl: String!
    private var _nextEvolutionId: String!
    private var _evolutionLevel: String!
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var evolutionLevel: String {
        if _evolutionLevel == nil {
            _evolutionLevel = ""
        }
        return _evolutionLevel
        }
    
     init(name: String,pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(BASE_URL)\(API_URL)\(self._pokedexId)/"
    }
    
    func downloadCompleted(complete: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            
            if let details = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = details["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = details["height"] as? String {
                    self._height = height
                }
                
                if let defense = details["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let attack = details["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._defense)
                print(self._attack)
                
                
                if let type = details["types"] as? [[String: String]] where type.count > 0 {
                    if let name = type[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if type.count > 1 {
                        for var x = 1; x < type.count; x++ {
                            if let name = type[x]["name"] {
                            self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                     
                } else {
                    self._type = ""
                }
                
                print(self._type)
               
                if let descriptions = details["descriptions"] as? [[String: String]] where descriptions.count > 0 {
                    
                    if let url = descriptions[0]["resource_uri"] {
                        let urlStr = NSURL(string: "\(BASE_URL)\(url)")!
                        
                        Alamofire.request(.GET, urlStr).responseJSON { response in
                            let result = response.result
                            
                            if let description = result.value as? [String: AnyObject] {
                                
                                if let desc = description["description"] as? String {
                                    self._description = desc
                                    print(self._description)
                                }
                            }
                        complete()
                        }
                    }
                    
                } else {
                    self._description = ""
                }
                    
                    if let evolution = details["evolutions"] as? [[String: AnyObject]] where evolution.count > 0 {
                       
                        if let to = evolution[0]["to"] as? String {
                            
                            if to.rangeOfString("mega") == nil {
                                
                                if let uri = evolution[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    
                                    self._nextEvolutionId = num
                                    self._nextEvolutionTxt = to
                                    
                                    if let level = evolution[0]["level"] as? Int {
                                        self._evolutionLevel = "\(level)"                                    }
                                }
                                
                                print(self._evolutionLevel)
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                            }
                        }
                    }
       
            }
          
      }
           
    }
  }


