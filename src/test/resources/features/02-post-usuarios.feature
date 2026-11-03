Feature: POST /usuarios - registrar usuarios
  Background:
    * url baseUrl

  @positivo
  Scenario: TC_04 - Registrar usuario valido y consultar persistencia
    * def payload = randomUser()
    Given path 'usuarios'
    And request payload
    When method post
    Then status 201
    And match response == createSchema
    And match response.message == 'Cadastro realizado com sucesso'
    * def userId = response._id
    Given path 'usuarios', userId
    When method get
    Then status 200
    And match response == userSchema
    And match response contains payload
    * call read('classpath:helpers/delete-user.feature') { userId: '#(userId)' }

  @negativo
  Scenario: TC_05 - Rechazar registro con email duplicado
    * def created = call read('classpath:helpers/create-user.feature')
    * def userId = created.userId
    Given path 'usuarios'
    And request created.user
    When method post
    Then status 400
    And match response == messageSchema
    And match response.message contains 'email'
    * call read('classpath:helpers/delete-user.feature') { userId: '#(userId)' }

  @negativo
  Scenario Outline: TC_06 - Rechazar payload con datos invalidos: <caso>
    * def payload = randomUser()
    * set payload.<campo> = <valor>
    Given path 'usuarios'
    And request payload
    When method post
    Then status 400
    And match response == '#object'
    And match response contains { <campo>: '#string' }
    Examples:
      | caso                 | campo         | valor       |
      | nombre vacio        | nome          | ''          |
      | correo invalido     | email         | 'incorrecto'|
      | password vacio      | password      | ''          |
      | rol invalido        | administrador | 'quizas'    |
