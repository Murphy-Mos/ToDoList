//
//  AuthorizationPresenterTest.swift
//  ToDoListTests
//
//  Created by Ahmed Ahmedov on 15.10.2021.
//

import XCTest
@testable import ToDoList

class MockRouter: AuthRouterInput {
    
    var isRouterMethodWasCalled = false
    
    func openToDoListVC() {
        isRouterMethodWasCalled = true
    }
}

class AuthorizationPresenterTest: XCTestCase {
    
    var presenter: AuthPresenter!
    var router = MockRouter()
    
    override func setUpWithError() throws {
        presenter = AuthPresenter()
        presenter.router = router
    }

    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func testModuleIsNotNil() {
        XCTAssertNotNil(presenter, "presenter is not nil")
    }
    
    func testUserInfoCorrect() {
        
        //Given
        let login = "1111"
        let password = "2222"
        var isRouterMethodWasCalled = false

        //When
        presenter.loginDidTap(login: login, password: password)

        //Then
        isRouterMethodWasCalled = router.isRouterMethodWasCalled
        XCTAssertEqual(isRouterMethodWasCalled, true)
    }
    
    func testUserfInfoNotCorrect() {
        
        //Given
        var isRouterMethodWasCalled = false

        //When
        presenter.loginDidTap(login: "", password: "qlkfdk")

        //Then
        isRouterMethodWasCalled = router.isRouterMethodWasCalled
        XCTAssertNotEqual(isRouterMethodWasCalled, true)
    }
}
