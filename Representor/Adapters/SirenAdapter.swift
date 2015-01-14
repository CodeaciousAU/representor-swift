//
//  SirenAdapter.swift
//  Representor
//
//  Created by Kyle Fuller on 08/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

private func sirenActionToTransition(action:[String: AnyObject]) -> (name:String, transition:Transition)? {
  if let name = action["name"] as? String {
    if let href = action["href"] as? String {
      let transition = Transition(uri: href) { builder in
        if let fields = action["fields"] as? [[String:AnyObject]] {
          for field in fields {
            if let name = field["name"] as? String {
              if let value = field["value"] as? String {
                builder.addAttribute(name, value: value as NSObject, defaultValue: nil)
              } else {
                builder.addAttribute(name)
              }
            }
          }
        }
      }

      return (name, transition)
    }
  }

  return nil
}

/// An extension to the Representor to add Siren support
/// It only supports siren links and properties
extension Representor {
  public init(siren:Dictionary<String, AnyObject>) {
    self.metadata = [:]

    if let sirenLinks = siren["links"] as? [Dictionary<String, AnyObject>] {
      var links = Dictionary<String, String>()

      for link in sirenLinks {
        if let href = link["href"] as? String {
          if let relations = link["rel"] as? [String] {
            for relation in relations {
              links[relation] = href
            }
          }
        }
      }

      self.links = links
    } else {
      self.links = [:]
    }

    if let entities = siren["entities"] as? [Dictionary<String, AnyObject>] {
      var representors = Dictionary<String, [Representor]>()

      for entity in entities {
        let representor = Representor(siren: entity)

        if let relations = entity["rel"] as? [String] {
          for relation in relations {
            if var reps = representors[relation] {
              reps.append(representor)
              representors[relation] = reps
            } else {
              representors[relation] = [representor]
            }
          }
        }
      }

      self.representors = representors
    } else {
      self.representors = [:]
    }

    if let actions = siren["actions"] as? [[String:AnyObject]] {
      var transitions = [String:Transition]()

      for action in actions {
        if let (name, transition) = sirenActionToTransition(action) {
          transitions[name] = transition
        }
      }

      self.transitions = transitions
    } else {
      self.transitions = [:]
    }

    if let properties = siren["properties"] as? Dictionary<String, AnyObject> {
      self.attributes = properties
    } else {
      self.attributes = [:]
    }
  }

  public func asSiren() -> Dictionary<String, AnyObject> {
    var representation = Dictionary<String, AnyObject>()

    if links.count > 0 {
      var links = [Dictionary<String, AnyObject>]()

      for (name, uri) in self.links {
        links.append(["rel": [name], "href": uri])
      }

      representation["links"] = links
    }

    if representors.count > 0 {
      var entities = [Dictionary<String, AnyObject>]()

      for (relation, representorSet) in representors {
        for representor in representorSet {
          var representation = representor.asSiren()
          representation["rel"] = [relation]
          entities.append(representation)
        }
      }

      representation["entities"] = entities
    }

    if attributes.count > 0 {
      representation["properties"] = attributes
    }

    return representation
  }
}
