Feature: DELETE /usuarios/{_id} - eliminar usuario
  Background:
    * url baseUrl

  @positivo
  Scenario: TC_12 - Eliminar usuario y comprobar que ya no existe
    * def created = call read('classpath:helpers/create-user.feature')
    * def userId = created.userId
    Given path 'usuarios', userId
    When method delete
    Then status 200
    And match response == messageSchema
    And match response.message == 'Registro excluído com sucesso'
    Given path 'usuarios', userId
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  @negativo
  Scenario: TC_13 - Eliminar ID inexistente no elimina ningun registro
    * def missingId = 'qa' + Java.type('java.util.UUID').randomUUID().toString().replace(/-/g, '').substring(0, 14)
    Given path 'usuarios', missingId
    When method delete
    Then status 200
    And match response == messageSchema
    And match response.message == 'Nenhum registro excluído'
