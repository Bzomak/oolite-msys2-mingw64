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

echo "$@"

exit 

if [[ "${{ steps.extract-data-single-word-result.outcome }}" == "success" ]]; then
SUCCESS_COUNT=$((SUCCESS_COUNT+1))
TEST_SUMMARY+="✔️ Extracting a single word from a file<br>"
else
FAILURE_COUNT=$((FAILURE_COUNT+1))
TEST_SUMMARY+="❌ Extracting a single word from a file<br>"
fi
if [[ "${{ steps.extract-data-multiple-words-result.outcome }}" == "success" ]]; then
SUCCESS_COUNT=$((SUCCESS_COUNT+1))
TEST_SUMMARY+="✔️ Extracting multiple words from a file<br>"
else
FAILURE_COUNT=$((FAILURE_COUNT+1))
TEST_SUMMARY+="❌ Extracting multiple words from a file<br>"
fi
if [[ "${{ steps.extract-data-multiple-lines-result.outcome }}" == "success" ]]; then
SUCCESS_COUNT=$((SUCCESS_COUNT+1))
TEST_SUMMARY+="✔️ Extracting multiple lines from a file<br>"
else
FAILURE_COUNT=$((FAILURE_COUNT+1))
TEST_SUMMARY+="❌ Extracting multiple lines from a file<br>"
fi
if [[ "${{ steps.extract-data-empty-result.outcome }}" == "success" ]]; then
SUCCESS_COUNT=$((SUCCESS_COUNT+1))
TEST_SUMMARY+="✔️ Extracting an empty file<br>"
else
FAILURE_COUNT=$((FAILURE_COUNT+1))
TEST_SUMMARY+="❌ Extracting an empty file<br>"
fi
if [[ "${{ steps.extract-non-existent-file-result.outcome }}" == "success" ]]; then
SUCCESS_COUNT=$((SUCCESS_COUNT+1))
TEST_SUMMARY+="✔️ Extracting from a non-existent file<br>"
else
FAILURE_COUNT=$((FAILURE_COUNT+1))
TEST_SUMMARY+="❌ Extracting from a non-existent file<br>"
fi
if [[ "${{ steps.extract-directory-result.outcome }}" == "success" ]]; then
SUCCESS_COUNT=$((SUCCESS_COUNT+1))
TEST_SUMMARY+="✔️ Extracting from a directory<br>"
else
FAILURE_COUNT=$((FAILURE_COUNT+1))
TEST_SUMMARY+="❌ Extracting from a directory<br>"
fi
if [[ "${{ steps.extract-empty-path-result.outcome }}" == "success" ]]; then
SUCCESS_COUNT=$((SUCCESS_COUNT+1))
TEST_SUMMARY+="✔️ Extracting from an empty path<br>"
else
FAILURE_COUNT=$((FAILURE_COUNT+1))
TEST_SUMMARY+="❌ Extracting from an empty path<br>"
fi

echo "## extract-data-string-from-file Test Results" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"
echo "### Passed ✔️: $SUCCESS_COUNT | Failed ❌: $FAILURE_COUNT" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"
echo "#### Tests:" >> "$GITHUB_STEP_SUMMARY"
echo "$TEST_SUMMARY" >> "$GITHUB_STEP_SUMMARY"
