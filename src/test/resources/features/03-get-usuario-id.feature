Feature: GET /usuarios/{_id} - buscar por ID
  Background:
    * url baseUrl

  @positivo
  Scenario: TC_07 - Consultar usuario creado por ID
    * def created = call read('classpath:helpers/create-user.feature')
    * def userId = created.userId
    Given path 'usuarios', userId
    When method get
    Then status 200
    And match response == userSchema
    And match response._id == userId
    And match response.email == created.user.email
    * call read('classpath:helpers/delete-user.feature') { userId: '#(userId)' }

  @negativo
  Scenario: TC_08 - Consultar ID inexistente
    * def missingId = 'qa' + Java.type('java.util.UUID').randomUUID().toString().replace(/-/g, '').substring(0, 14)
    Given path 'usuarios', missingId
    When method get
    Then status 400
    And match response == messageSchema
    And match response.message == 'Usuário não encontrado'
