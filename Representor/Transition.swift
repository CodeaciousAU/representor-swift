//
//  Transition.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public struct InputProperty<T : AnyObject> : Equatable {
  public let defaultValue:T?
  public let value:T?

  // TODO: Define validators

  public init(value:T?, defaultValue:T?) {
    self.value = value
    self.defaultValue = defaultValue
  }
}

public func ==<T : AnyObject>(lhs:InputProperty<T>, rhs:InputProperty<T>) -> Bool {
  return (
    lhs.defaultValue as? NSObject == rhs.defaultValue as? NSObject &&
    lhs.value as? NSObject == rhs.value as? NSObject
  )
}

public typealias InputProperties = Dictionary<String, InputProperty<AnyObject>>

/** Transition instances encapsulate information about interacting with links and forms. */
public protocol Transition : Equatable, Hashable {
  typealias Builder = TransitionBuilder

  init(uri:String, attributes:InputProperties, parameters:InputProperties)
  init(uri:String, _ block:((builder:Builder) -> ()))

  var uri:String { get }

  var attributes:InputProperties { get }
  var parameters:InputProperties { get }
}

public struct HTTPTransition : Transition {
  public typealias Builder = HTTPTransitionBuilder

  public let uri:String

  public let attributes:InputProperties
  public let parameters:InputProperties

  public init(uri:String, attributes:InputProperties, parameters:InputProperties) {
    self.uri = uri
    self.attributes = attributes
    self.parameters = parameters
  }

  public init(uri:String, _ block:((builder:Builder) -> ())) {
    let builder = Builder()

    block(builder: builder)

    self.uri = uri
    self.attributes = builder.attributes
    self.parameters = builder.parameters
  }

  public var hashValue:Int {
    return uri.hashValue
  }
}

public func ==(lhs:HTTPTransition, rhs:HTTPTransition) -> Bool {
  return (
    lhs.uri == rhs.uri &&
    lhs.attributes == rhs.attributes &&
    lhs.parameters == rhs.parameters
  )
}
