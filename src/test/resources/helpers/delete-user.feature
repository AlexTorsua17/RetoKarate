Feature: Helper - limpieza de usuario temporal
  Scenario: Eliminar usuario creado por la suite
    * def userId = __arg.userId
    Given url baseUrl
    And path 'usuarios', userId
    When method delete
    Then status 200
    And match response == messageSchema
