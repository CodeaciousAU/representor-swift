//
//  TransitionBuilder.swift
//  HypermediaResource
//
//  Created by Kyle Fuller on 05/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public class TransitionBuilder {
    var attributes = InputProperties()
    var parameters = InputProperties()

    // MARK: Attributes

    public func addAttribute(name:String, value:AnyObject?, defaultValue:AnyObject?) {
        let property = InputProperty(value:value, defaultValue:defaultValue)
        attributes[name] = property
    }

    // MARK: Parameters

    public func addParameter(name:String, value:AnyObject?, defaultValue:AnyObject?) {
        let property = InputProperty(value:value, defaultValue:defaultValue)
        parameters[name] = property
    }
}

extension Transition {
    public init(uri:String, _ block:((builder:TransitionBuilder) -> ())) {
        let builder = TransitionBuilder()

        block(builder: builder)

        self.uri = uri
        self.attributes = builder.attributes
        self.parameters = builder.parameters
    }
}
