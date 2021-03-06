//
//  Utils.swift
//  Representor
//
//  Created by Kyle Fuller on 18/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation
import Representor

func fixture(named:String, forObject:AnyObject) -> NSData {
  let bundle = NSBundle(forClass:object_getClass(forObject))
  let path = bundle.URLForResource(named, withExtension: "json")!
  let data = NSData(contentsOfURL: path)!
  return data
}

func JSONFixture(named:String, forObject:AnyObject) -> [String:AnyObject] {
  let data = fixture(named, forObject: forObject)
  let object = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  return object as! [String:AnyObject]
}

func PollFixtureAttributes(forObject:AnyObject) -> [String:AnyObject] {
  return JSONFixture("poll.attributes", forObject: forObject)
}

func PollFixture(forObject:AnyObject) -> Representor<HTTPTransition> {
  return Representor { builder in
    builder.addTransition("self", uri:"/polls/1/")
    builder.addTransition("next", uri:"/polls/2/")

    builder.addAttribute("question", value:"Favourite programming language?")
    builder.addAttribute("published_at", value:"2014-11-11T08:40:51.620Z")
    builder.addAttribute("choices", value:[
      [
        "answer": "Swift",
        "votes": 2048,
      ], [
        "answer": "Python",
        "votes": 1024,
      ], [
        "answer": "Objective-C",
        "votes": 512,
      ], [
        "answer": "Ruby",
        "votes": 256,
      ],
    ])

    builder.addRepresentor("next") { builder in
      builder.addTransition("self", uri:"/polls/2/")
      builder.addTransition("next", uri:"/polls/3/")
      builder.addTransition("previous", uri:"/polls/1/")
    }
  }
}
