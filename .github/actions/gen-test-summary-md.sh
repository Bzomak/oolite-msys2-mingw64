#! /usr/bin/bash

###############################
#
# Take a list of outcomes and names of tests and generate Markdown for "$GITHUB_STEP_SUMMARY"
#
# Usage: Call `bash gen-test-summary-md.sh [input_path]` from the run step in the workflow file
#
###############################

SUCCESS_COUNT=0
FAILURE_COUNT=0
TEST_SUMMARY=""

# Check that the number of arguments is even (pairs of name and result)
if (( $# % 2 != 0 )); then
    echo "Error: Arguments must come in pairs of name and result"
    exit 1
fi

# Iterate over arguments two at a time
for ((i=1; i<=$#; i+=2)); do
    # Use indirect parameter expansion to get the value of the argument
    name="${!i}"
    result="${!((i+1))}"

    # Validate the name and result
    if [[ -z "$name" ]]; then
        echo "Error: Name at position $i is empty"
        exit 1
    fi
    if [[ -z "$result" ]]; then
        echo "Error: Result at position $((i+1)) is empty"
        exit 1
    fi

    # Now you can use $name and $result in your script
    echo "Name: $name, Result: $result"

    if [[ $result == "success" ]]; then
        SUCCESS_COUNT=$((SUCCESS_COUNT+1))
        TEST_SUMMARY+="✔️ $name<br>"
    else
        FAILURE_COUNT=$((FAILURE_COUNT+1))
        TEST_SUMMARY+="❌ $name<br>"
    fi
done

# Generate the summary markdown
echo "## extract-data-string-from-file Test Results" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"
echo "### Passed ✔️: $SUCCESS_COUNT | Failed ❌: $FAILURE_COUNT" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"
echo "#### Tests:" >> "$GITHUB_STEP_SUMMARY"
echo "$TEST_SUMMARY" >> "$GITHUB_STEP_SUMMARY"
