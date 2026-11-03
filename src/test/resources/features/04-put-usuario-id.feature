Feature: PUT /usuarios/{_id} - actualizar usuario
  Background:
    * url baseUrl

  @positivo
  Scenario: TC_09 - Actualizar usuario existente y verificar persistencia
    * def created = call read('classpath:helpers/create-user.feature')
    * def userId = created.userId
    * def updated = randomUser()
    Given path 'usuarios', userId
    And request updated
    When method put
    Then status 200
    And match response == messageSchema
    And match response.message == 'Registro alterado com sucesso'
    Given path 'usuarios', userId
    When method get
    Then status 200
    And match response == userSchema
    And match response contains updated
    * call read('classpath:helpers/delete-user.feature') { userId: '#(userId)' }

  @negativo
  Scenario: TC_10 - Rechazar actualizacion con correo ya registrado
    * def first = call read('classpath:helpers/create-user.feature')
    * def second = call read('classpath:helpers/create-user.feature')
    * def firstId = first.userId
    * def secondId = second.userId
    * def payload = randomUser()
    * set payload.email = first.user.email
    Given path 'usuarios', secondId
    And request payload
    When method put
    Then status 400
    And match response == messageSchema
    And match response.message contains 'email'
    * call read('classpath:helpers/delete-user.feature') { userId: '#(firstId)' }
    * call read('classpath:helpers/delete-user.feature') { userId: '#(secondId)' }

  @positivo
  Scenario: TC_11 - PUT sobre ID inexistente crea registro (comportamiento ServeRest)
    * def missingId = 'qa' + Java.type('java.util.UUID').randomUUID().toString().replace(/-/g, '').substring(0, 14)
    * def payload = randomUser()
    Given path 'usuarios', missingId
    And request payload
    When method put
    Then status 201
    And match response == createSchema
    * def userId = response._id
    Given path 'usuarios', userId
    When method get
    Then status 200
    And match response contains payload
    * call read('classpath:helpers/delete-user.feature') { userId: '#(userId)' }
