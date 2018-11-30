#!/bin/bash

# TODO Reformat the output results into a file so that BitBucket can register them
sfdx force:lightning:lint ./force-app/main --exit --verbose

echo "Creating the Scratch Org..."
sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias TestRunner --setdefaultusername

echo "Pushing source code..."
sfdx force:source:push --targetusername TestRunner

echo "Running unit tests..."
sfdx force:apex:test:run --testlevel RunLocalTests --outputdir test-results --resultformat tap --targetusername TestRunner --codecoverage --wait 6

sfdx force:org:delete --noprompt --targetusername TestRunner