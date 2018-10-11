#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# no public APIs here
# SHELLDOC-IGNORE

# shellcheck disable=2034
if [[ "${CIRCLECI}" = true ]]; then
  if [[ ${CIRCLE_REPOSITORY_URL} =~ github.com ]]; then
    # github artifacts show up like so:
    #BUILD_URL_ARTIFACTS=https://circle-artifacts.com/gh/username/repo/buildnum/artifacts/0/dir/file
    # but test-patch doesn't support URLs that aren't tied to the build_url.  so that
    # needs to get rewritten first before this can be used

    BUILD_URL="https://circleci.com/gh/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/${CIRCLE_BUILD_NUM}"
    BUILD_URL_CONSOLE='/'
    CONSOLE_USE_BUILD_URL=false
    ROBOT=true
    ROBOTTYPE=circleci


    yetus_comma_to_array CPR "${CIRCLE_PULL_REQUESTS}"

    if [[ "${#CIRCLE_PULL_REQUESTS[@]}" -ne 1 ]]; then
      BUILDMODE=full
      USER_PARAMS+=("--empty-patch")
    else
      PATCH_OR_ISSUE="${CIRCLE_PULL_REQUEST}"
      USER_PARAMS+=("${CIRCLE_PULL_REQUEST}")
    fi

    add_docker_env \
      CIRCLECI \
      CIRCLE_BUILD_NUM \
      CIRCLE_PULL_REQUEST \
      CIRCLE_PULL_REQUESTS \
      CIRCLE_PROJECT_USERNAME \
      CIRCLE_PROJECT_REPONAME \
      CIRCLE_REPOSITORY_URL

    yetus_add_entry EXEC_MODES Circle_CI
  fi
fi

function circleci_set_plugin_defaults
{
  if [[ ${CIRCLE_REPOSITORY_URL} =~ github.com ]]; then
    if [[ "${#CIRCLE_PULL_REQUESTS[@]}" -eq 1 ]]; then
      github_breakup_url "${CIRCLE_PULL_REQUEST}"
    fi
    GITHUB_REPO=${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}
  fi
}