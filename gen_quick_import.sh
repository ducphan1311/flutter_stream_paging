Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore

@ducphan1311
dangngocduc
/
sapo_app
Private
generated from dangngocduc/flutter_application
Code
Issues
83
Pull requests
Actions
Projects
1
Security
Insights
sapo_app/gen_quick_import.sh
@dangngocduc
dangngocduc Initial commit
Latest commit 549f3a9 on Oct 1, 2021
 History
 1 contributor
37 lines (35 sloc)  963 Bytes

#!/bin/bash

function genQuickImport() {
  SPACE="$1"
  cd "$SPACE" || exit
  echo  "$SPACE"
  FOLDER_NAME=$(basename "$PWD")
  if test -f "$FOLDER_NAME.dart"; then
      rm -f "$FOLDER_NAME.dart"
  fi
  echo "$FOLDER_NAME.dart"
  touch "$FOLDER_NAME.dart"
  echo "// GENERATED CODE - DO NOT MODIFY BY HAND" >> "$FOLDER_NAME.dart"
  echo "// Read more on README.md/Utils" >> "$FOLDER_NAME.dart"
  for entry in *
  do
    if [[ $entry  ==  *.g.dart || $entry  ==  *.freezed.dart ]]; then
      continue
    fi
    if [[ $entry  !=  *.g.dart ]]; then
          if [[ $entry == *.dart ]]; then
              if [[ $entry != $FOLDER_NAME.dart ]]; then
                echo "export '$entry';" >> "$FOLDER_NAME.dart"
              fi
          else
            (
              echo "export '$entry/$entry.dart';" >> "$FOLDER_NAME.dart"
              genQuickImport "$entry"
            )
          fi
    fi
  done
  cd ..
}
# Change Folder At Here
genQuickImport lib

Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
You have no unread notifications