@mobile @smoke
Feature: Mobile Test

  As a User
  I want to be able to see the same Wiki Page on Mobile and on Desktop App.

  Background:
    Given User navigates to "WIKI"

  @mobile
  @Wiki-test_01
  Scenario: Verify that User is able to search FC Barcelona on Wikipedia
    Then User waits for Search Input "wikiPage|searchField" visibility within 60 seconds
    Then Search Button "wikiPage|searchButton" is displayed
    When User enters "FC Barcelona" in Search Input "wikiPage|searchField"
      And User clicks Search Button "wikiPage|searchButton"
      And User waits 3 seconds
    Then Result Header "wikiResultPage|resultHeader" text is equal to "FC Barcelona"