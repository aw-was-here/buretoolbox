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

load functions_test_helper

@test "yetus_file_to_array (empty)" {
  run yetus_file_to_array ARRAY "nonexistent"
  [ "${status}" = 1 ]
}

@test "yetus_file_to_array (basic read)" {
  run yetus_file_to_array ARRAY "${TESTRESOURCES}/arrayfiletest.txt"
  [ "${status}" = 0 ]
}

@test "yetus_file_to_array (contents)" {
  yetus_file_to_array ARRAY "${TESTRESOURCES}/arrayfiletest.txt"
  [ "${ARRAY[0]}" = 1 ]
}

@test "yetus_file_to_array (count)" {
  yetus_file_to_array ARRAY "${TESTRESOURCES}/arrayfiletest.txt"
  [ "${#ARRAY[@]}" -eq 3 ]
}