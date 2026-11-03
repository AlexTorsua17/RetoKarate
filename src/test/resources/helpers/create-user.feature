Feature: Helper - crear usuario temporal
  Scenario: Crear usuario
    * def payload = (__arg && __arg.payload) ? __arg.payload : randomUser()
    Given url baseUrl
    And path 'usuarios'
    And request payload
    When method post
    Then status 201
    And match response == createSchema
    * def userId = response._id
    * def user = payload
