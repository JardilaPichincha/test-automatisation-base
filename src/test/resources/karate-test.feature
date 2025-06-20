Feature: Test de API para superheroes prueba pichincha

  Background:
    * configure ssl = true
    * def id = Math.floor(Math.random() * 10000)
    * def random = java.util.UUID.randomUUID().toString()
    * def nombreCreate = 'Prueba Pichincha' + random + id
  @id:1 @get @getPersonajes
  Scenario: Obtener personajes
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    When method get
    Then status 200
    And match response == '#[]'
    Then assert response.length > 0

  @id:2 @get @getPersonajesErr
  Scenario: GET Error al obtener un personaje que no existe
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/9999999'
    When method get
    Then status 404
    And assert response.error == 'Character not found'
  @id:3 @get @getPersonajesSuc
  Scenario: GET para obteber un personaje que si existe
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/972'
    When method get
    Then status 200
    And assert response.id == 972
  @id:4 @post @postCreateSuc
  Scenario: Post para crear un recurso
      Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
      And request
      """
      {
        "name": '#(nombreCreate)',
        "alterego": "Alt prueba",
        "description": "Prueba des",
        "powers": ["Armor", "Flight"]
      }
      """
      When method post
      Then status 201
  @id:5 @post @postCreateErr
  Scenario: Post Error al crear un personaje ya existente
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    And request
      """
      {
        "name": 'Prueba Pichinchae131f0c1-b584-47c5-af37-2b68d033c2ec6690',
        "alterego": "Otro",
        "description": "Otro",
        "powers": ["Armor"]
      }
      """
    When method post
    Then status 400
    And assert response.error == 'Character name already exists'
  @id:6 @post @postCreate400
  Scenario: Post para un personaje cuando faltan campos
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    And request
      """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    When method post
    Then status 400
    Then print response
    And assert response.name == 'Name is required'
    And assert response.description == 'Description is required'
    And assert response.alterego == 'Alterego is required'
  @id:7 @put @putUpdateSuc
  Scenario: Put para actualizar información
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/972'
    And request
      """
      {
        "id": 972,
        "name": "Prueba Pichinchae131f0c1-b584-47c5-af37-2b68d033c2ec6690",
        "alterego": "Otro",
        "description": "Otro",
        "powers": [
          "Armor"
        ]
      }
      """
    When method put
    Then status 200
    And assert response.id == 972
    And assert response.name == 'Prueba Pichinchae131f0c1-b584-47c5-af37-2b68d033c2ec6690'
    And assert response.description == 'Otro'
    And assert response.powers.length > 0
    And assert response.alterego == 'Otro'
  @id:8 @put @putUpdate404
  Scenario: Put para actualizar información de un personaje que no existe
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/999999'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 404
    And assert response.error == 'Character not found'

  @id:9 @delete @putUpdate404
  Scenario: Delete cuando se elimina y no existe el personaje
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/9999999'
    When method delete
    Then status 404
    And assert response.error == 'Character not found'