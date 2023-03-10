/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const autolifecycle = require('./lib/autolifecycle');

module.exports.autolifecycle = autolifecycle;
module.exports.contracts = [autolifecycle];
