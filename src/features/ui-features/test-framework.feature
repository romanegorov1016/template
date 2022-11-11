@smoke
Feature: Test framework work
    Demonstarte test framework

    Scenario: Verify search functionality works correctly
        Given User navigates to "https://www.wikipedia.org/"
        When User enters "Isaac Newton" in [Search field] "#searchInput"
            And User clicks [Search button] "button[type=submit]"
        Then [Page title] "#firstHeading" text is equal to "Isaac Newton"
            And Page URL contains "/Isaac_Newton"

  # for an explanation of hard vs soft test assertions please see the comment on soft assert
  # in the beforeScenario() function in common_config.js
  @soft_assert_enable
  Scenario: Verify soft asserts work
    Given User navigates to "https://www.wikipedia.org/"
    When User enters "Isaac Newton" in Search field "wikiPage|searchField"
      And User clicks Search button "wikiPage|searchButton"
    Then Page title "#firstHeading" text is equal to "Isaac Newton FAIL"
      And Page title "#firstHeading" text is equal to "Isaac Newton ONE MORE FAIL"
      And Page title "#firstHeading" text is equal to "Isaac Newton THE LAST FAIL"
      And User compares screenshot of Portrait "wikiResultPage|infoBoxPortrait" to "portrait.png"
      And Page URL contains "/Isaac_Newton"


  Scenario: Verify intercept service work
    Given User navigates to "https://petstore.swagger.io/"
    When User starts itersepting API
      And User clicks [Button] "button" with text "Explore"
    Then User verifies intercepted "/swagger.json" request is success


  @example
  Scenario: Verify framework work
    Given User navigates to "https://petstore.swagger.io/"
    Then Page URL is equal to "https://petstore.swagger.io/"
