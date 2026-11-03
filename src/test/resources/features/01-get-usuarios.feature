Feature: GET /usuarios - listado de usuarios
  Background:
    * url baseUrl

  @Test01
  Scenario: TC_01 - Listar usuarios y validar estructura JSON
    Given path 'usuarios'
    When method get
    Then status 200
    And match response == { quantidade: '#number', usuarios: '#[]' }
    And match response.quantidade == response.usuarios.length
    And match each response.usuarios == userSchema

  @Test02
  Scenario: TC_02 - Filtrar usuarios por correo creado en la prueba
    * def created = call read('classpath:helpers/create-user.feature')
    * def userId = created.userId
    * def email = created.user.email
    Given path 'usuarios'
    And param email = email
    When method get
    Then status 200
    And match response.quantidade == 1
    And match response.usuarios == '#[1]'
    And match response.usuarios[0]._id == userId
    And match response.usuarios[0].email == email
    * call read('classpath:helpers/delete-user.feature') { userId: '#(userId)' }

  @negativo
  Scenario: TC_03 - Filtrar por correo que no existe devuelve lista vacia
    * def nonexistent = 'missing.' + Java.type('java.util.UUID').randomUUID() + '@example.com'
    Given path 'usuarios'
    And param email = nonexistent
    When method get
    Then status 200
    And match response == { quantidade: 0, usuarios: [] }
