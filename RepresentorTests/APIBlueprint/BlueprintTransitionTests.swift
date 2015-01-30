//
//  BlueprintTransitionTests.swift
//  Representor
//
//  Created by Kyle Fuller on 28/01/2015.
//  Copyright (c) 2015 Apiary LTD. All rights reserved.
//

import Foundation
import XCTest
import Representor

class BlueprintTransitionTests: XCTestCase {
  func testResourceToTransitions() {
    let parameter = Parameter(name: "name", description: nil, type: "string", required: true, defaultValue: "default", example: "value", values: nil)
    let action = Action(name: "Create", description: nil, method: "PATCH", parameters: [parameter])
    let resource = Resource(name: "Post", description: nil, uriTemplate: "/polls", parameters: [parameter], actions: [action])
    let resourceGroup = ResourceGroup(name: "Name", description: nil, resources: [resource])
    let blueprint = Blueprint(name: "Blueprint", description: nil, resourceGroups: [resourceGroup])

    let transition = blueprint.transition("Post", action:"Create")!
    let transitionParameter = transition.parameters["name"]!

    XCTAssertEqual(transition.uri, "/polls")
    XCTAssertEqual(transition.method, "PATCH")
    XCTAssertEqual(Array(transition.parameters.keys), ["name"])
    XCTAssertEqual(transitionParameter.value as String, "value")
    XCTAssertEqual(transitionParameter.defaultValue as String, "default")
  }
}
