#!/bin/sh

cp /action/problem-matcher.json /github/workflow/problem-matcher.json

# Install Composer if not found
if ! [ -x "$(command -v composer)" ]; then
  echo 'Composer not found, installing...'
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
fi

composer global config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
composer global require --dev wp-coding-standards/wpcs:"^3.0.0" --update-with-dependencies

git config --global --add safe.directory $(pwd)

diff_lines() {
  path=""
  line=""
  while IFS= read -r REPLY; do
     esc=$(printf '\033')
     if echo "$REPLY" | grep -qE '\-\-\- (a/)?.*'; then
         continue
     elif echo "$REPLY" | grep -qE '\+\+\+ (b/)?([^[:blank:]'"$esc"']+).*'; then
         path=$(echo "$REPLY" | sed -E 's/\+\+\+ (b\/)?([^[:blank:]'"$esc"']+).*/\2/')
     elif echo "$REPLY" | grep -qE '@@ -[0-9]+(,[0-9]+)? \+([0-9]+)(,[0-9]+)? @@.*'; then
         line=$(echo "$REPLY" | sed -E 's/@@ -[0-9]+(,[0-9]+)? \+([0-9]+)(,[0-9]+)? @@.*/\2/')
     elif echo "$REPLY" | grep -qE '^('"$esc"'\[[0-9;]*m)*([\\ +-])'; then
         echo "$path:$line:$REPLY"
         if echo "${REPLY}" | grep -qE '^('"$esc"'\[[0-9;]*m)*([\ +-])'; then
             line=$((line+1))
         fi
     fi
  done
}

filter_by_changed_lines() {
    changedLines="$1"
    fileName=
    fileLine=
    exitCode=0

    while IFS= read -r line; do
        if echo "$line" | grep -q -E '<file name="(\/github\/workspace\/)?([^"]+)'; then
            fileName=$(echo "$line" | sed -E 's/.*<file name="(\/github\/workspace\/)?([^"]+).*/\2/')
            echo "$line"
        elif echo "$line" | grep -q -E '<error line="([^"]+)'; then
            fileLine=$(echo "$line" | sed -E 's/.*<error line="([^"]+).*/\1/')
            if echo "$changedLines" | grep -qx "$fileName:$fileLine"; then
                exitCode=1
                echo "$line"
            fi
        else
            echo "$line"
        fi
    done
    exit "$exitCode"
}

clean_diff_output() {
  step1=$(git diff -U0 --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}")
  step2=$(echo "${step1}" | diff_lines)
  step3=$(echo "${step2}" | grep -ve ':-')
  step4=$(echo "${step3}" | sed 's/:+.*//') # On some platforms, sed needs to have + escaped.  This isn't the case for Alpine sed.
  step5=$(echo "${step4}" | sed 's/:\\.*//')

  echo "${step5}"
}

decide_all_files_or_changed() {
  standards="$1"

  if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
      if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
        set +e
        echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${standards}" | filter_by_changed_lines "${clean_diff_output}"
        set -e
      else
        echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${standards}"
      fi
  else
      ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${standards}"
  fi
}

INPUT_ONLY_CHANGED_FILES=${INPUT_ONLY_CHANGED_FILES:-${INPUT_ONLY_CHANGED_LINES:-"false"}}

if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
    if [ "${GITHUB_EVENT_NAME}" = "pull_request" ]; then
        COMPARE_FROM=origin/${GITHUB_BASE_REF}
        COMPARE_TO=origin/${GITHUB_HEAD_REF}

        COMPARE_FROM_REF=$(git merge-base "${COMPARE_FROM}" "${COMPARE_TO}")
        COMPARE_TO_REF=${COMPARE_TO}
    else
        COMPARE_FROM="HEAD^"
        COMPARE_TO="HEAD"
        COMPARE_FROM_REF="HEAD^"
        COMPARE_TO_REF="HEAD"
    fi
    echo "Will only check changed files (${COMPARE_FROM_REF} -> ${COMPARE_TO_REF})"
    set +e
    CHANGED_FILES=$(git diff --name-only --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}" | xargs -rt ls -1d 2>/dev/null)
    set -e
    echo "Will check files:"
    echo "${CHANGED_FILES}"
else
    echo "Will check all files"
fi

if [ "${INPUT_STANDARD}" = "WordPress-VIP-Go" ] || [ "${INPUT_STANDARD}" = "WordPressVIPMinimum" ]; then
    echo "Setting up VIPCS"
    git clone --depth 1 -b 2.3.3 https://github.com/Automattic/VIP-Coding-Standards.git ${HOME}/vipcs
    git clone https://github.com/sirbrillig/phpcs-variable-analysis ${HOME}/variable-analysis

    decide_all_files_or_changed "$(composer config home)/vendor/wp-coding-standards/wpcs,${HOME}/vipcs,${HOME}/variable-analysis"
elif [ "${INPUT_STANDARD}" = "10up-Default" ]; then
    echo "Setting up 10up-Default"
    git clone https://github.com/10up/phpcs-composer ${HOME}/10up
    git clone https://github.com/PHPCompatibility/PHPCompatibilityWP ${HOME}/phpcompatwp
    git clone https://github.com/PHPCompatibility/PHPCompatibility ${HOME}/phpcompat
    git clone https://github.com/PHPCompatibility/PHPCompatibilityParagonie ${HOME}/phpcompat-paragonie
    git clone --depth 1 --branch 1.0.11 https://github.com/PHPCSStandards/PHPCSUtils ${HOME}/phpcsutils
    git clone https://github.com/Automattic/VIP-Coding-Standards ${HOME}/vipcs
    git clone https://github.com/sirbrillig/phpcs-variable-analysis ${HOME}/variable-analysis

    decide_all_files_or_changed "$(composer config home)/vendor/wp-coding-standards/wpcs,${HOME}/10up/10up-Default,${HOME}/phpcompatwp/PHPCompatibilityWP,${HOME}/phpcompat/PHPCompatibility,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieSodiumCompat,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieRandomCompat,${HOME}/phpcsutils/PHPCSUtils,${HOME}/vipcs,${HOME}/variable-analysis"
elif [ -z "${INPUT_STANDARD_REPO}" ] || [ "${INPUT_STANDARD_REPO}" = "false" ]; then
  echo "Setting up default WPCS"
  git clone --depth 1 --branch 1.0.11 https://github.com/PHPCSStandards/PHPCSUtils ${HOME}/phpcsutils
  decide_all_files_or_changed "$(composer config home)/vendor/wp-coding-standards/wpcs,${HOME}/phpcsutils/PHPCSUtils"
else
  echo "Standard repository: ${INPUT_STANDARD_REPO}"
  git clone -b ${INPUT_REPO_BRANCH} ${INPUT_STANDARD_REPO} ${HOME}/cs

  decide_all_files_or_changed "$(composer config home)/vendor/wp-coding-standards/wpcs,${HOME}/cs"
fi

if [ -z "${INPUT_EXCLUDES}" ]; then
    EXCLUDES="node_modules,vendor"
else
    EXCLUDES="node_modules,vendor,${INPUT_EXCLUDES}"
fi

phpcs -i

echo "::add-matcher::${RUNNER_TEMP}/_github_workflow/problem-matcher.json"

if [ -z "${INPUT_ENABLE_WARNINGS}" ] || [ "${INPUT_ENABLE_WARNINGS}" = "false" ]; then
    WARNING_FLAG="-n"
    echo "Check for warnings disabled"
else
    WARNING_FLAG=""
    echo "Check for warnings enabled"
fi

# .phpcs.xml, phpcs.xml, .phpcs.xml.dist, phpcs.xml.dist
if [ -f ".phpcs.xml" ] || [ -f "phpcs.xml" ] || [ -f ".phpcs.xml.dist" ] || [ -f "phpcs.xml.dist" ]; then
    HAS_CONFIG=true
else
    HAS_CONFIG=false
fi

if [ "${HAS_CONFIG}" = true ] && [ "${INPUT_USE_LOCAL_CONFIG}" = "true" ] ; then
  if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
      if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
        set +e
        echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle ${INPUT_EXTRA_ARGS} | filter_by_changed_lines "${clean_diff_output}"
        status=$?
        set -e
      else
        echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle ${INPUT_EXTRA_ARGS}
        status=$?
      fi
  else
      ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle ${INPUT_EXTRA_ARGS}
      status=$?
  fi
else
  if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
    if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
      set +e
      echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --extensions=php ${INPUT_EXTRA_ARGS} | filter_by_changed_lines "$(clean_diff_output)"
      status=$?
      set -e
    else
      echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --extensions=php ${INPUT_EXTRA_ARGS}
      status=$?
    fi
  else
    ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --ignore=${EXCLUDES} --extensions=php ${INPUT_PATHS} ${INPUT_EXTRA_ARGS}
    status=$?
  fi
fi

echo "::remove-matcher owner=phpcs::"

exit $status
