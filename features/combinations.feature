Feature: List all valid combinations

  Scenario: List all possible first-column values
    When I ask for all possible first-column values
    Then the output should be exactly caretaker,infant,object

  Scenario: Prevent second column from duplicating the first
    Given the first column is <First>
    When the second column is <First>
    Then that's an invalid duplicate value
    Examples:
    | First     |
    | caretaker |
    | object    |
    | infant    |

  Scenario: List all possible second-column values
    When I ask for all possible second-column values
    Then the output should be exactly caretaker,infant,object

  Scenario: List all possible third-column values
    When I ask for all possible third-column values
    Then the output should be exactly dif,i,smile,S

  Scenario: Prevent third-column values that don't match first
    Given the first column is <First>
    When the third column is <Third>
    Then that's an invalid combination
    Examples:
    | First     | Third |
    | caretaker | smile |
    | caretaker | i     |
    | object    | smile |
    | object    | i     |
    | object    | dif   |
    | object    | S     |
    | infant    | S     |

  Scenario: Prevent third-column values that don't match second
    Given the second column is <Second>
    When the third column is <Third>
    Then that's an invalid combination
    Examples:
    | Second    | Third |
    | caretaker | dif   |
    | infant    | dif   |

  Scenario: List all possible primitive combinations
    When I ask for all possible combinations of columns
    Then the output should have 14 combinations

  Scenario: Prevent primitive combination repeating in 2-combo
    Given the first combo is <First>
    When the second combo is <Second>
    Then that's an invalid duplicate combo
    Examples:
    | First              | Second               |
    | caretaker infant   | caretaker infant     |
    | caretaker infant   | caretaker infant S   |
    | caretaker infant S | caretaker infant     |
    | caretaker object   | caretaker object dif |
    | caretaker object   | caretaker object S   |
    | caretaker object S | caretaker object dif |

  Scenario: Generate no invalid 2-combos from inputs
    Given the primitive combinations caretaker infant,caretaker infant S
    When I ask for the possible 2-combos
    Then there should be no output

  Scenario: Generate valid 2-combos from inputs
    Given the primitive combinations <Input>
    When I ask for the possible 2-combos
    Then the output should be <Output>
    Examples:
    | Input                                                      | Output                                                                   |
    | caretaker infant S,caretaker object                        | caretaker object caretaker infant S,caretaker infant S caretaker object  |
    | caretaker infant S,caretaker object S,caretaker object dif | caretaker object S caretaker infant S,caretaker infant S caretaker object S,caretaker object dif caretaker infant S,caretaker infant S caretaker object dif |

  Scenario: List all possible 2-combos
    When I ask for all possible 2-combos
    Then the output should have 156 combos

# 3-combo, 4-combo, 5-combo, 6-combo
# list all 2-, 3-, 4-, 5-, and 6-combos.
# remove all the spaces and commas. done!
